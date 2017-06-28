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
        %HandlingEvent{id: 1, type: "RECEIVE", tracking_id: "ABC123", location: "CHHKG",
                completion_time: elem(DateTime.from_iso8601("2017-06-20T23:00:00Z"), 1) },
        %HandlingEvent{id: 2, type: "LOAD", tracking_id: "ABC123", location: "CHHKG",
                completion_time: elem(DateTime.from_iso8601("2017-06-22T23:00:00Z"), 1) },
        %HandlingEvent{id: 3, type: "UNLOAD", tracking_id: "ABC123", location: "USNYC",
                completion_time: elem(DateTime.from_iso8601("2017-06-29T23:00:00Z"), 1) },
      ]
  end

  def all(Cargo) do
    [
      %Cargo{id: 1, tracking_id: "ABC123", status: "IN PORT"},
      %Cargo{id: 2, tracking_id: "IJK456", status: "ON CARRIER"}
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

  def get_by_tracking_id!(HandlingEvent, tracking_id) do
    all(HandlingEvent)
    |> Enum.filter(fn handling_event -> handling_event.tracking_id == tracking_id end)
  end

  def get_by_tracking_id!(Cargo, tracking_id) do
    all(Cargo)
    |> Enum.find(fn cargo -> cargo.tracking_id == tracking_id end)
  end
end
