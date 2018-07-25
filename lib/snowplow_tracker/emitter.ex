defmodule SnowplowTracker.Emitter do
  @moduledoc """
  This module is responsible for sending events to the
  snowplow collector.
  """
  alias __MODULE__

  alias SnowplowTracker.{Payload, Request, Response, Errors}
  alias SnowplowTracker.Emitters.Helper

  @keys [
    collector_uri: "localhost",
    request_type: "GET",
    collector_port: nil,
    protocol: "http"
  ]

  defstruct @keys

  @type t :: %__MODULE__{
          collector_uri: String.t(),
          request_type: String.t(),
          collector_port: number(),
          protocol: String.t()
        }

  # Public API

  @spec new(Emitter.t()) :: Emitter.t()
  def new(uri), do: struct(%Emitter{}, collector_uri: uri)

  @spec input(Payload.t(), Emitter.t(), struct()) :: {:ok, String.t()} | no_return()
  def input(%Payload{} = payload, %Emitter{} = emitter, module \\ Helper) do
    url =
      module.generate_endpoint(
        emitter.protocol,
        emitter.collector_uri,
        emitter.collector_port,
        Payload.get(payload),
        emitter.request_type
      )

    with {:ok, response} <- Request.get(url, [recv_timeout: 50000]),
         {:ok, body} <- Response.parse(response) do
      {:ok, body}
    else
      {:error, error} ->
        raise Errors.ApiError, Kernel.inspect(error)
    end
  end
end
