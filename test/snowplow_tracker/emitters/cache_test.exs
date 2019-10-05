defmodule SnowplowTracker.Emitters.CacheTest do
  use ExUnit.Case

  alias SnowplowTracker.Emitters.Cache

  @table :snowplow_events_test

  setup_all do
    try do
      Cache.delete_table(@table)
    rescue
      _ -> :ok
    end

    :ok
  end

  describe "init/1" do
    test "creates ets table" do
      Cache.init(@table)

      assert(Enum.member?(:ets.all(), @table))

      Cache.delete_table(@table)
    end
  end

  describe "insert/1" do
    test "inserts payload into ets table" do
      Cache.init(@table)
      Cache.insert({"test", "value"}, @table)

      response = :ets.lookup(@table, "test")
      assert(response == [{"test", "value"}])
      Cache.delete_table(@table)
    end
  end

  describe "match/1" do
    test "returns data from ETS that matches pattern" do
      Cache.init(@table)
      Cache.insert({"test", "value1", "value2"}, @table)
      response = Cache.match(@table)
      assert response == {:ok, [["test", "value1", "value2"]]}
      Cache.delete_table(@table)
    end
  end

  describe "check_lock/1" do
    test "returns empty response if lock is not present" do
      Cache.init(@table)
      response = Cache.check_lock(@table)
      assert response == {:ok, []}
      Cache.delete_table(@table)
    end

    test "returns lock if it is present" do
      Cache.init(@table)
      Cache.insert({"lock", "true"}, @table)
      response = Cache.check_lock(@table)
      assert response == {:ok, [{"lock", "true"}]}
      Cache.delete_table(@table)
    end
  end

  describe "release_lock/1" do
    test "deletes the lock in the ETS table" do
      Cache.init(@table)
      Cache.insert({"lock", "true"}, @table)
      response = Cache.release_lock({:ok, "test"}, @table)
      assert response == {:ok, :success}
      Cache.delete_table(@table)
    end

    test "does not delete lock if error in parent step" do
      Cache.init(@table)
      Cache.insert({"lock", "true"}, @table)
      Cache.release_lock({:error, "test"}, @table)
      response = Cache.check_lock(@table)
      assert response == {:ok, [{"lock", "true"}]}
      Cache.delete_table(@table)
    end
  end

  describe "set_lock/1" do
    test "sets lock in the ETS table" do
      Cache.init(@table)
      response = Cache.set_lock(@table)
      assert response == {:ok, :success}
      Cache.delete_table(@table)
    end

    test "fails to set lock if table is not present" do
      response = Cache.set_lock(@table)
      assert response == {:error, :failed}
    end
  end

  describe "delete_key/2" do
    test "deletes specified key from table" do
      Cache.init(@table)
      Cache.insert({"test", "value"}, @table)
      response = Cache.delete_key("test", @table)
      assert response == {:ok, :success}
      Cache.delete_table(@table)
    end
  end

  describe "delete_table/1" do
    test "deletes ETS table" do
      Cache.init(@table)
      Cache.delete_table(@table)
      refute(Enum.member?(:ets.all(), @table))
    end
  end
end
