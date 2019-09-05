defmodule Snowplow.Events.ServerTest do
  use ExUnit.Case

  alias SnowplowTracker.Emitters.Server

  describe "insert/2" do
    test "inserts payload in ets table" do
      {:ok, pid} = Server.start_link(nil)

      Server.insert({"test", "value"}, pid)

      assert :ets.lookup(:snowplow_events, "test") == {:ok}
    end
  end
end
