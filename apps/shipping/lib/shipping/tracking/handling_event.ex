defmodule Shipping.Tracking.HandlingEvent do
  use Ecto.Schema
  import Ecto.Changeset
  alias Shipping.Tracking.HandlingEvent


  schema "handling_events" do
    field :completionTime, :utc_datetime
    field :location, :string
    field :registrationTime, :utc_datetime
    field :trackingId, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(%HandlingEvent{} = handling_event, attrs) do
    handling_event
    |> cast(attrs, [:type, :location, :completionTime, :registrationTime, :trackingId])
    |> validate_required([:type, :location, :completionTime, :registrationTime, :trackingId])
  end
end
