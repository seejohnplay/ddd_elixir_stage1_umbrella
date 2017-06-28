defmodule Shipping.Repo.Migrations.CreateCargoes do
  use Ecto.Migration

  def change do
    create table(:cargoes) do
      add :tracking_id, :string
      add :status, :string

      timestamps()
    end

  end
end
