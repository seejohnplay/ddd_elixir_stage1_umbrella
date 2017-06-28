defmodule Shipping.TrackingTest do
  use Shipping.DataCase

  alias Shipping.Tracking

  describe "cargoes" do
    alias Shipping.Tracking.Cargo

    @valid_attrs %{status: "some status", tracking_id: "some tracking_id"}
    @update_attrs %{status: "some updated status", tracking_id: "some updated tracking_id"}
    @invalid_attrs %{status: nil, tracking_id: nil}

    def cargo_fixture(attrs \\ %{}) do
      {:ok, cargo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tracking.create_cargo()

      cargo
    end

    test "list_cargoes/0 returns all cargoes" do
      cargo = cargo_fixture()
      assert Tracking.list_cargoes() == [cargo]
    end

    test "get_cargo!/1 returns the cargo with given id" do
      cargo = cargo_fixture()
      assert Tracking.get_cargo!(cargo.id) == cargo
    end

    test "create_cargo/1 with valid data creates a cargo" do
      assert {:ok, %Cargo{} = cargo} = Tracking.create_cargo(@valid_attrs)
      assert cargo.status == "some status"
      assert cargo.tracking_id == "some tracking_id"
    end

    test "create_cargo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracking.create_cargo(@invalid_attrs)
    end

    test "update_cargo/2 with valid data updates the cargo" do
      cargo = cargo_fixture()
      assert {:ok, cargo} = Tracking.update_cargo(cargo, @update_attrs)
      assert %Cargo{} = cargo
      assert cargo.status == "some updated status"
      assert cargo.tracking_id == "some updated tracking_id"
    end

    test "update_cargo/2 with invalid data returns error changeset" do
      cargo = cargo_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracking.update_cargo(cargo, @invalid_attrs)
      assert cargo == Tracking.get_cargo!(cargo.id)
    end

    test "delete_cargo/1 deletes the cargo" do
      cargo = cargo_fixture()
      assert {:ok, %Cargo{}} = Tracking.delete_cargo(cargo)
      assert_raise Ecto.NoResultsError, fn -> Tracking.get_cargo!(cargo.id) end
    end

    test "change_cargo/1 returns a cargo changeset" do
      cargo = cargo_fixture()
      assert %Ecto.Changeset{} = Tracking.change_cargo(cargo)
    end
  end

  describe "handling_events" do
    alias Shipping.Tracking.HandlingEvent

    @valid_attrs %{cargo_id: "some cargo_id", completion_time: "some completion_time", cargo_id: "some cargo_id", registration_time: "some registration_time", type: "some type"}
    @update_attrs %{cargo_id: "some updated cargo_id", completion_time: "some updated completion_time", cargo_id: "some updated cargo_id", registration_time: "some updated registration_time", type: "some updated type"}
    @invalid_attrs %{cargo_id: nil, completion_time: nil, cargo_id: nil, registration_time: nil, type: nil}

    def handling_event_fixture(attrs \\ %{}) do
      {:ok, handling_event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tracking.create_handling_event()

      handling_event
    end

    test "list_handling_events/0 returns all handling_events" do
      handling_event = handling_event_fixture()
      assert Tracking.list_handling_events() == [handling_event]
    end

    test "get_handling_event!/1 returns the handling_event with given id" do
      handling_event = handling_event_fixture()
      assert Tracking.get_handling_event!(handling_event.id) == handling_event
    end

    test "create_handling_event/1 with valid data creates a handling_event" do
      assert {:ok, %HandlingEvent{} = handling_event} = Tracking.create_handling_event(@valid_attrs)
      assert handling_event.cargo_id == "some cargo_id"
      assert handling_event.completion_time == "some completion_time"
      assert handling_event.cargo_id == "some cargo_id"
      assert handling_event.registration_time == "some registration_time"
      assert handling_event.type == "some type"
    end

    test "create_handling_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracking.create_handling_event(@invalid_attrs)
    end

    test "update_handling_event/2 with valid data updates the handling_event" do
      handling_event = handling_event_fixture()
      assert {:ok, handling_event} = Tracking.update_handling_event(handling_event, @update_attrs)
      assert %HandlingEvent{} = handling_event
      assert handling_event.cargo_id == "some updated cargo_id"
      assert handling_event.completion_time == "some updated completion_time"
      assert handling_event.cargo_id == "some updated cargo_id"
      assert handling_event.registration_time == "some updated registration_time"
      assert handling_event.type == "some updated type"
    end

    test "update_handling_event/2 with invalid data returns error changeset" do
      handling_event = handling_event_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracking.update_handling_event(handling_event, @invalid_attrs)
      assert handling_event == Tracking.get_handling_event!(handling_event.id)
    end

    test "delete_handling_event/1 deletes the handling_event" do
      handling_event = handling_event_fixture()
      assert {:ok, %HandlingEvent{}} = Tracking.delete_handling_event(handling_event)
      assert_raise Ecto.NoResultsError, fn -> Tracking.get_handling_event!(handling_event.id) end
    end

    test "change_handling_event/1 returns a handling_event changeset" do
      handling_event = handling_event_fixture()
      assert %Ecto.Changeset{} = Tracking.change_handling_event(handling_event)
    end
  end
end
