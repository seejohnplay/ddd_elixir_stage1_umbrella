defmodule Shipping.Tracking.Cargo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Shipping.Tracking.Cargo


  schema "cargoes" do
    field :status, :string
    field :trackingId, :string

    timestamps()
  end

  @doc false
  def changeset(%Cargo{} = cargo, attrs) do
    cargo
    |> cast(attrs, [:trackingId, :status])
    |> validate_required([:trackingId, :status])
  end
end
