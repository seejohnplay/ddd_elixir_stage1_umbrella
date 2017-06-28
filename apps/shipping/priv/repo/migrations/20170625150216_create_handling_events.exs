defmodule Shipping.Repo.Migrations.CreateHandlingEvents do
  use Ecto.Migration

  def change do
    create table(:handling_events) do
      add :type, :string
      add :location, :string
      add :completion_time, :string
      add :registration_time, :string
      add :tracking_id, :string

      timestamps()
    end

  end
end
