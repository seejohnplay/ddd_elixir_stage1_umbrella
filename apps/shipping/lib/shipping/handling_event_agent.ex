defmodule Shipping.HandlingEventAgent do
  @moduledoc """
  HandlingEventAgent is an Agent that maintains a state which contains
  the HandlingEvent's that have arrived and also the last id that was
  assigned to the event before storage. This agent is supervised - see Shipping.Application

  A backing store - a file - contains all events past and present. It is read
  when this Agent is started (start_link() and is written to (appended) when a
  new handling event is inserted. The backing store data is stored in
  JSON format.
  """
  defstruct [events: [], last_event_id: 0, cache: nil]

  alias Shipping.Tracking.HandlingEvent

  @doc """
  Before starting the Agent process, start_link first loads any Handling Events
  that might be stored in the file cache ("handling_events.json"). Any events
  become part of Agent's state.
  """
  def start_link do
    {:ok, cache} = File.open("handling_events.json", [:append, :read])
    {events, last_event_id} = load_from_cache(cache, {[], 0})
    Agent.start_link(fn -> %__MODULE__{cache: cache, events: events, last_event_id: last_event_id} end, name: __MODULE__)
  end

  defp load_from_cache(cache, {events, last_event_id} = acc) do
    case IO.read(cache, :line) do
      :eof -> acc
      event ->
        event_struct =
          event
            |> String.trim_trailing("\n")
            |> Poison.decode!(as: %HandlingEvent{})
        load_from_cache(cache, {[event_struct | events], event_struct.id})
    end
  end

  @doc """
  Return all of the Handling Events in the agents state as a list. This function
  is meant to act like a database select all.
  """
  def all() do
    Agent.get(__MODULE__, fn(struct) -> struct.events end)
  end

  @doc """
  Add a handling event to the current state and append it to the cache file. This
  function is meant to behave like a database insert.
  """
  def add(%HandlingEvent{} = event) do
    id = next_id()
    new_event = %{event | id: id}
    Agent.update(__MODULE__,
      fn(struct) ->
        %{struct | events: [new_event | struct.events]}
      end)
    cache = Agent.get(__MODULE__, fn(s) -> s.cache end)
    IO.write(cache, to_json(new_event) <> "\n")
    new_event
  end

  defp to_json(event) do
    # Remove Ecto field before encoding
    event |> Map.delete(:__meta__) |> Poison.encode!
  end

  def next_id() do
    Agent.get_and_update(__MODULE__,
    fn(struct) ->
      next_id = struct.last_event_id + 1
      {next_id, %{struct | last_event_id: next_id}}
    end)
  end

end
