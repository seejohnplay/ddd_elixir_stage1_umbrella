defmodule Shipping.Repo.Migrations.CreateHandlingEvents do
  use Ecto.Migration

  def change do
    create table(:handling_events) do
      add :type, :string
      add :locationId, :string
      add :completionTime, :string
      add :registrationTime, :string
      add :cargoId, :string

      timestamps()
    end

  end
end
