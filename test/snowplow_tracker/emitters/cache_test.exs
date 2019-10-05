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

    Cache.init(@table)

    on_exit(fn ->
      Cache.delete_table(@table)
    end)

    :ok
  end

  describe "insert/1" do
    test "inserts payload into ets table" do
      Cache.insert({"test", "value"}, @table)

      response = :ets.lookup(@table, "test")
      assert(response == [{"test", "value"}])
    end
  end

  describe "match/1" do
    test "returns data from ETS that matches pattern" do
      Cache.insert({"test", "value1", "value2"}, @table)
      response = Cache.match(@table)
      assert response == {:ok, [["test", "value1", "value2"]]}
    end
  end

  describe "check_lock/1" do
    test "returns lock if it is present" do
      Cache.insert({"lock", "true"}, @table)
      response = Cache.check_lock(@table)
      assert response == {:ok, [{"lock", "true"}]}
    end
  end

  describe "release_lock/1" do
    test "deletes the lock in the ETS table" do
      Cache.insert({"lock", "true"}, @table)
      response = Cache.release_lock({:ok, "test"}, @table)
      assert response == {:ok, :success}
    end

    test "does not delete lock if error in parent step" do
      Cache.insert({"lock", "true"}, @table)
      Cache.release_lock({:error, "test"}, @table)
      response = Cache.check_lock(@table)
      assert response == {:ok, [{"lock", "true"}]}
    end
  end

  describe "set_lock/1" do
    test "sets lock in the ETS table" do
      response = Cache.set_lock(@table)
      assert response == {:ok, :success}
    end
  end

  describe "delete_key/2" do
    test "deletes specified key from table" do
      Cache.insert({"test", "value"}, @table)
      response = Cache.delete_key("test", @table)
      assert response == {:ok, :success}
    end
  end
end
