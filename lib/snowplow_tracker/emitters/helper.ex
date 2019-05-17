defmodule SnowplowTracker.Emitters.Helper do
  @moduledoc """
  This module contains helper functions to format and sanitize the data
  necessary for the emitter module
  """

  alias SnowplowTracker.{Request, Errors, Constants}

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

  def make_request(url, _params, _options, retry_count) when retry_count == 0 do
    {:error, "Failed after retry. URL: #{url}"}
  end

  def make_request(url, params, options, retry_count \\ 10) do
    try do
      {:ok, response} = Request.get(url, params, options)
      {:ok, response}
    rescue
      _error ->
        make_request(url, params, options, retry_count - 1)
    end
  end
end
