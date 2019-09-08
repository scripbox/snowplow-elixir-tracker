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
    on_exit(fn -> Cache.delete_table(@table) end)
    :ok
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
end
