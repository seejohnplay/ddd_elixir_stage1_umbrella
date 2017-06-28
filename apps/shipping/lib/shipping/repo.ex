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

  def all(HandlingEvent) do
      [
        %HandlingEvent{id: 1, type: "RECEIVE", trackingId: "ABC123", location: "CHHKG",
                completionTime: elem(DateTime.from_iso8601("2017-06-20T23:00:00Z"), 1) },
        %HandlingEvent{id: 2, type: "LOAD", trackingId: "ABC123", location: "CHHKG",
                completionTime: elem(DateTime.from_iso8601("2017-06-22T23:00:00Z"), 1) },
        %HandlingEvent{id: 3, type: "UNLOAD", trackingId: "ABC123", location: "USNYC",
                completionTime: elem(DateTime.from_iso8601("2017-06-29T23:00:00Z"), 1) },
      ]
  end

  def all(Cargo) do
    [
      %Cargo{id: 1, trackingId: "ABC123", status: "IN PORT"},
      %Cargo{id: 2, trackingId: "IJK456", status: "ON CARRIER"}
    ]
  end


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

  def get!(HandlingEvent, id) do
    all(HandlingEvent)
    |> Enum.find(fn handling_event -> handling_event.id == id end)
  end

  def get!(Cargo, id) when is_binary(id) do
    get!(Cargo, String.to_integer(id))
  end
  def get!(Cargo, id) do
    all(Cargo)
    |> Enum.find(fn cargo -> cargo.id == id end)
  end

  def get_by_trackingId!(HandlingEvent, trackingId) do
    all(HandlingEvent)
    |> Enum.filter(fn handling_event -> handling_event.trackingId == trackingId end)
  end

  def get_by_trackingId!(Cargo, trackingId) do
    all(Cargo)
    |> Enum.find(fn cargo -> cargo.trackingId == trackingId end)
  end
end
