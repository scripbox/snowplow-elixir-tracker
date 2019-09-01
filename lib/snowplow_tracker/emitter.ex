defmodule SnowplowTracker.Emitter do
  @moduledoc """
  This module is responsible for sending events to the
  snowplow collector.
  """
  alias __MODULE__
  alias SnowplowTracker.Payload
  alias SnowplowTracker.Emitters.{Bulk, Lone, Helper}

  @keys [
    collector_uri: "localhost",
    request_type: "GET",
    collector_port: nil,
    protocol: "http"
  ]
  @type t :: %__MODULE__{
          collector_uri: String.t(),
          request_type: String.t(),
          collector_port: number(),
          protocol: String.t()
        }

  defstruct @keys

  # Public API

  @spec new(Emitter.t()) :: Emitter.t()
  def new(uri), do: struct(%Emitter{}, collector_uri: uri)

  @spec input(Payload.t(), Emitter.t(), struct()) :: {:ok, String.t()} | no_return()
  def input(payload, emitter, module \\ Helper)

  def input(%Payload{} = payload, %Emitter{request_type: "GET"} = emitter, module) do
    url =
      module.generate_endpoint(
        emitter.protocol,
        emitter.collector_uri,
        emitter.collector_port,
        Payload.get(payload),
        emitter.request_type
      )

    Lone.create(payload, url)
  end

  def input(%Payload{} = payload, %Emitter{request_type: "POST"} = emitter, module) do
    url =
      module.generate_endpoint(
        emitter.protocol,
        emitter.collector_uri,
        emitter.collector_port,
        payload,
        emitter.request_type
      )

    GenServer.call(Bulk, {:create, payload, url}, 60_000)
  end
end
