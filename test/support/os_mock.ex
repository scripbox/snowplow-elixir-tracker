defmodule SnowplowTracker.OsMock do
  def system_time(_) do
    send(self(), "timestamp generated")
  end
end
