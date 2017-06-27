defmodule Shipping.Repo do
  # use Ecto.Repo, otp_app: :shipping
  #
  # @doc """
  # Dynamically loads the repository url from the
  # DATABASE_URL environment variable.
  # """
  # def init(_, opts) do
  #   {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  # end
  alias Shipping.Tracking.{HandlingEvent, Cargo}

  ##############################################################################
  # Support for Handling Events
  ##############################################################################
  # TODO: Store the HandlingEvent in an Agent or to disk
  def insert(%Ecto.Changeset{data: %HandlingEvent{} = handlingEvent} = changeset) do
    if changeset.valid? do
      {:ok, %{changeset.data | id: 1}}  # TODO: should be incremented
    else
      {:error, %{changeset | action: :insert}}
    end
  end

  def get!(HandlingEvent, id) when is_binary(id) do
    get!(HandlingEvent, String.to_integer(id))
  end
  ######################################################################
  ###### TODO: Remove hard-wired return of handling event
  def get!(HandlingEvent, id) do
    %HandlingEvent{id: id, trackingId: "ABC123" }    
  end

  ##############################################################################
  # Support for Cargoes
  ##############################################################################
  # schema "cargoes" do
  #   field :status, :string
  #   field :trackingId, :string
  #
  #   timestamps()
  # end

  def all(Cargo) do
    [
      %Cargo{id: 1, trackingId: "ABC123", status: "IN PORT"},
      %Cargo{id: 2, trackingId: "IJK456", status: "ON CARRIER"}
    ]
  end

  def get!(Cargo, id) when is_binary(id) do
    get!(Cargo, String.to_integer(id))
  end
  def get!(Cargo, id) do
    all(Cargo)
    |> Enum.find(fn cargo -> cargo.id == id end)
  end
end
