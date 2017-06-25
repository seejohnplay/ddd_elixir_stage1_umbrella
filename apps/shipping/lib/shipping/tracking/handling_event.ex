defmodule Shipping.Tracking.HandlingEvent do
  use Ecto.Schema
  import Ecto.Changeset
  alias Shipping.Tracking.HandlingEvent


  schema "handling_events" do
    field :cargoId, :string
    field :completionTime, :string
    field :locationId, :string
    field :registrationTime, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(%HandlingEvent{} = handling_event, attrs) do
    handling_event
    |> cast(attrs, [:type, :locationId, :completionTime, :registrationTime, :cargoId])
    |> validate_required([:type, :locationId, :completionTime, :registrationTime, :cargoId])
  end
end
