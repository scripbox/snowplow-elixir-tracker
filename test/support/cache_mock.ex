defmodule SnowplowTracker.CacheMock do
  require HTTPoison

  def insert(payload) do
    send(self(), "Insert successful")
    {:ok, payload}
  end
end
