defmodule SnowplowTracker.Emitters.CacheTest do
  use ExUnit.Case

  alias SnowplowTracker.Emitters.Cache

  @table Application.get_env(:snowplow_tracker, :table)
  describe "init/1" do
    test "creates ets table" do
      Cache.init()

      assert(Enum.member?(:ets.all(), @table))
    end
  end

  describe "insert/1" do
    test "inserts payload into ets table" do
      require IEx
      IEx.pry()
      Cache.insert({"test", "value"})

      response = :ets.lookup(@table, "test")
      assert(response == "value")
    end
  end
end
