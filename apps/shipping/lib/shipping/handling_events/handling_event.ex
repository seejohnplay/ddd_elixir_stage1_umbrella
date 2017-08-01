defmodule Shipping.HandlingEvents.HandlingEvent do
  use Ecto.Schema
  import Ecto.Changeset
  # The Aggregate is HandlingEvents
  alias Shipping.HandlingEvents.HandlingEvent
  # Cargoes Aggregates
  alias Shipping.Cargoes


  schema "handling_events" do
    field :completion_time, :utc_datetime
    field :location, :string
    field :registration_time, :utc_datetime
    field :tracking_id, :string
    field :type, :string
    field :voyage, :string, default: ""

    timestamps()
  end

  @doc """
  Create a new HandlingEvent, initializing the registration_time to be the
  creation time (now).
  """
  def new() do
    %HandlingEvent{registration_time: DateTime.utc_now()}
  end

  @doc false
  def changeset(%HandlingEvent{} = handling_event, attrs) do
    handling_event
    |> cast(attrs, [:type, :location, :completion_time, :registration_time, :tracking_id, :voyage])
    |> validate_required([:type, :location, :completion_time, :registration_time, :tracking_id])
    |> validate_tracking_id()
  end

  @doc """
  A cargo with this tracking id needs to exist.
  """
  defp validate_tracking_id(handling_event) do
    case Cargoes.get_cargo_by_tracking_id!(get_field(handling_event, :tracking_id)) do
      nil -> add_error(handling_event, :tracking_id, "Cannot find tracking number.")
      cargo -> handling_event          
    end
  end

end
