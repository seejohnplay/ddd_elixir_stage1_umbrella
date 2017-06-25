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
  # schema "handling_events" do
  #   field :cargoId, :string
  #   field :completionTime, :string
  #   field :locationId, :string
  #   field :registrationTime, :string
  #   field :type, :string
  #
  #   timestamps()
  # end

  def all(HandlingEvent) do
    [
      %HandlingEvent{id: 1, type: "RECEIVE", cargoId: "ABC123", locationId: "CHHKG"},
      %HandlingEvent{id: 2, type: "LOAD", cargoId: "ABC123", locationId: "CHHKG"},
      %HandlingEvent{id: 3, type: "UNLOAD", cargoId: "ABC123", locationId: "USNYC"}
    ]
  end

  def get!(HandlingEvent, id) when is_binary(id) do
    get!(HandlingEvent, String.to_integer(id))
  end
  def get!(HandlingEvent, id) do
    all(HandlingEvent)
    |> Enum.find(fn handling_event -> handling_event.id == id end)
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
