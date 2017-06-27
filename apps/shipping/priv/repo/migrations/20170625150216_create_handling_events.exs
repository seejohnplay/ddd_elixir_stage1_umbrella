defmodule Shipping.Repo.Migrations.CreateHandlingEvents do
  use Ecto.Migration

  def change do
    create table(:handling_events) do
      add :type, :string
      add :location, :string
      add :completionTime, :string
      add :registrationTime, :string
      add :trackingId, :string

      timestamps()
    end

  end
end
