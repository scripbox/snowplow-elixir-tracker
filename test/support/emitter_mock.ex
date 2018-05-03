defmodule SnowplowTracker.EmitterMock do
  alias SnowplowTracker.Payload
  alias __MODULE__

  @keys [
    collector_uri: "localhost",
    request_type: "GET",
    collector_port: nil,
    protocol: "http"
  ]

  defstruct @keys

  def input(%Payload{} = _payload, %EmitterMock{} = _emitter) do
    {:ok, "successful response"}
  end
end
