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

      iex> get_cargo_by_trackingId!(123)
      %Cargo{}

      iex> get_cargo_by_trackingId!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cargo_by_trackingId!(trackingId), do: Repo.get_by_trackingId!(Cargo, trackingId)

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

      iex> get_handling_event_by_trackingId!(123)
      [%HandlingEvent{}]

      iex> get_handling_event_by_trackingId!(456)
      ** (Ecto.NoResultsError)

  """
  def get_handling_events_by_trackingId!(trackingId), do: Repo.get_by_trackingId!(HandlingEvent, trackingId)

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
    "Cutsoms": "CUSTOMS"
  }

  def handling_event_type_map do
    @handling_event_type_map
  end

end
