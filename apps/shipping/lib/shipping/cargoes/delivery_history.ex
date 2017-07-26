defmodule Shipping.Cargoes.DeliveryHistory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Shipping.HandlingEvents.HandlingEvent


  schema "delivery_histories" do
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
  end
end
