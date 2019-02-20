defmodule SnowplowTracker.Support.Emitters.Helper do
  @moduledoc """
  This module contains helper functions to format and sanitize the data
  necessary for the emitter module
  """

  alias SnowplowTracker.{Errors, Constants}

  @get_method "GET"

  # Public API

  @doc """
  This function is used to generate the endpoint with the query parameters
  which are used to send events to the collector.
  """
  def generate_endpoint(protocol, uri, nil = _port, payload, @get_method) do
    do_generate_endpoint(protocol, uri, "", payload)
  end

  def generate_endpoint(protocol, uri, port, payload, @get_method) do
    do_generate_endpoint(protocol, uri, ":#{port}", payload)
  end

  def generate_endpoint(_protocol, _uri, _port, _payload, invalid_method) do
    message = "#{invalid_method} method not implemented"
    raise Errors.NotImplemented, message
  end

  # Private API

  @doc false
  defp do_generate_endpoint(protocol, uri, port, payload) do
    params = URI.encode_query(payload)
    "#{protocol}://#{uri}#{port}/#{protocol_path()}?#{params}"
  end

  @doc false
  defp protocol_path do
    Constants.get_protocol_path()
  end
end
