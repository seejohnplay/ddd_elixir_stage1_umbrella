defmodule Shipping.Tracking do
  @moduledoc """
  The boundary for the Tracking system.
  """

  import Ecto.Query, warn: false
  alias Shipping.Repo

  alias Shipping.Tracking.Cargo

  @doc """
  Returns the list of cargoes.

  ## Examples

      iex> list_cargoes()
      [%Cargo{}, ...]

  """
  def list_cargoes do
    Repo.all(Cargo)
  end

  @doc """
  Gets a single cargo.

  Raises `Ecto.NoResultsError` if the Cargo does not exist.

  ## Examples

      iex> get_cargo!(123)
      %Cargo{}

      iex> get_cargo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cargo!(id), do: Repo.get!(Cargo, id)

  @doc """
  Gets a cargo by its tracking id.

  Raises `Ecto.NoResultsError` if the Cargo does not exist.

  ## Examples

      iex> get_cargo_by_tracking_id!(123)
      %Cargo{}

      iex> get_cargo_by_tracking_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cargo_by_tracking_id!(tracking_id), do: Repo.get_by_tracking_id!(Cargo, tracking_id)

  @doc """
  Creates a cargo.

  ## Examples

      iex> create_cargo(%{field: value})
      {:ok, %Cargo{}}

      iex> create_cargo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cargo(attrs \\ %{}) do
    %Cargo{}
    |> Cargo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cargo.

  ## Examples

      iex> update_cargo(cargo, %{field: new_value})
      {:ok, %Cargo{}}

      iex> update_cargo(cargo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cargo(%Cargo{} = cargo, attrs) do
    cargo
    |> Cargo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Cargo.

  ## Examples

      iex> delete_cargo(cargo)
      {:ok, %Cargo{}}

      iex> delete_cargo(cargo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cargo(%Cargo{} = cargo) do
    Repo.delete(cargo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cargo changes.

  ## Examples

      iex> change_cargo(cargo)
      %Ecto.Changeset{source: %Cargo{}}

  """
  def change_cargo(%Cargo{} = cargo) do
    Cargo.changeset(cargo, %{})
  end

  alias Shipping.Tracking.HandlingEvent

  @doc """
  Returns the list of handling_events.

  ## Examples

      iex> list_handling_events()
      [%HandlingEvent{}, ...]

  """
  def list_handling_events do
    Repo.all(HandlingEvent)
  end

  @doc """
  Gets all handling events for a tracking id.

  Raises `Ecto.NoResultsError` if the Handling event does not exist.

  ## Examples

      iex> get_handling_event_by_tracking_id!(123)
      [%HandlingEvent{}]

      iex> get_handling_event_by_tracking_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_handling_events_by_tracking_id!(tracking_id) do
    Repo.get_by_tracking_id!(HandlingEvent, tracking_id)
  end

  @doc """
  Gets a single handling_event.

  Raises `Ecto.NoResultsError` if the Handling event does not exist.

  ## Examples

      iex> get_handling_event!(123)
      %HandlingEvent{}

      iex> get_handling_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_handling_event!(id), do: Repo.get!(HandlingEvent, id)

  @doc """
  Creates a handling_event.

  ## Examples

      iex> create_handling_event(%{field: value})
      {:ok, %HandlingEvent{}}

      iex> create_handling_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_handling_event(attrs \\ %{}) do
    HandlingEvent.new()
    |> HandlingEvent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a handling_event.

  ## Examples

      iex> update_handling_event(handling_event, %{field: new_value})
      {:ok, %HandlingEvent{}}

      iex> update_handling_event(handling_event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_handling_event(%HandlingEvent{} = handling_event, attrs) do
    handling_event
    |> HandlingEvent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a HandlingEvent.

  ## Examples

      iex> delete_handling_event(handling_event)
      {:ok, %HandlingEvent{}}

      iex> delete_handling_event(handling_event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_handling_event(%HandlingEvent{} = handling_event) do
    Repo.delete(handling_event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking handling_event changes.

  ## Examples

      iex> change_handling_event(handling_event)
      %Ecto.Changeset{source: %HandlingEvent{}}

  """
  def change_handling_event(%HandlingEvent{} = handling_event) do
    HandlingEvent.changeset(handling_event, %{})
  end

  @doc """
  Based on a cargo's current status and a list of handling events a new
  cargo status is determined, the cargo is updated with this status and a
  tuple containing the tracking status and the updated cargo is returned.
  The tracking status is either :on_track or :off_track Note that tracking
  status is not currently used anywhere in the Stage 1 demo.
  """
  def update_cargo_status(handling_events) when is_list(handling_events) do
    cargo = get_cargo_by_tracking_id!(List.first(handling_events).tracking_id)
    do_update_cargo_status(handling_events, :on_track, cargo)
  end
  def update_cargo_status(handling_event) do
    cargo = get_cargo_by_tracking_id!(handling_event.tracking_id)
    do_update_cargo_status([handling_event], :on_track, cargo)
  end
  defp do_update_cargo_status([%HandlingEvent{type: type} | handling_events],
                          _tracking_status,
                          %Cargo{status: status} = cargo) do
    {next_tracking_status, next_status} = next_status(type, status)
    # IO.puts("STATUS: #{status} TYPE: #{type} NEXT: #{next_status}")
    do_update_cargo_status(handling_events, next_tracking_status, %{cargo | :status => next_status})
  end
  defp do_update_cargo_status([], tracking_status, cargo) do
    # Update the cargo with this final status
    case update_cargo(cargo, %{}) do
      {:ok, cargo} -> {tracking_status, cargo}
      {:error, cargo} -> {:error, cargo}
      _ -> {:error, cargo}
    end
    {tracking_status, cargo}
  end

  # State transistion for cargo status given a handling event
  # This is incomplete.
  defp next_status("RECEIVE", "NOT RECEIVED"), do: {:on_track, "IN PORT"}
  defp next_status("CUSTOMS", "IN PORT"), do: {:on_track, "IN PORT"}
  defp next_status("CLAIM", "IN PORT"), do: {:on_track, "CLAIMED"}
  defp next_status("LOAD", "CLEARED"), do: {:on_track, "ON CARRIER"}
  defp next_status("LOAD", "RECEIVED"), do: {:on_track, "ON CARRIER"}
  defp next_status("LOAD", "IN PORT"), do: {:on_track, "ON CARRIER"}
  defp next_status("LOAD", "ON CARRIER"), do: {:off_track, "ON CARRIER"}
  defp next_status("UNLOAD", "ON CARRIER"), do: {:on_track, "IN PORT"}
  defp next_status("UNLOAD", "IN PORT"), do: {:off_track, "IN PORT"}
  defp next_status(_, status), do: {:off_track, status}

  #############################################################################
  # Support for Locations
  #############################################################################
  @location_map  %{
    "Hongkong": "CHHKG",
    "Melbourne": "AUMEL",
    "Stockholm": "SESTO",
    "Helsinki": "FIHEL",
    "Chicago": "USCHI",
    "Tokyo": "JPTKO",
    "Hamburg": "DEHAM",
    "Shanghai": "CNSHA",
    "Rotterdam": "NLRTM",
    "Goteborg": "SEGOT",
    "Hangzhou": "CHHGH",
    "New York": "USNYC",
    "Dallas": "USDAL"
  }

  def location_map do
    @location_map
  end

  #############################################################################
  # Support for HandlingEvent types
  #############################################################################
  @handling_event_type_map %{
    "Load": "LOAD",
    "Unload": "UNLOAD",
    "Receive": "RECEIVE",
    "Claim": "CLAIM",
    "Customs": "CUSTOMS"
  }

  def handling_event_type_map do
    @handling_event_type_map
  end

end
