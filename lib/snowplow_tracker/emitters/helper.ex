defmodule SnowplowTracker.Emitters.Helper do
  @moduledoc """
  This module contains helper functions to format and sanitize the data
  necessary for the emitter module
  """

  alias SnowplowTracker.Constants

  @get_method "GET"
  @post_method "POST"

  # Public API

  @doc """
  This function is used to generate the endpoint with the query parameters
  which are used to send events to the collector.
  """
  def generate_endpoint(protocol, uri, nil = _port, payload, request_method) do
    do_generate_endpoint(
      protocol, 
      uri, 
      "", 
      payload, 
      request_method
    )
  end

  def generate_endpoint(protocol, uri, port, payload, request_method) do
    do_generate_endpoint(
      protocol, 
      uri, 
      ":#{port}", 
      payload, 
      request_method
    )
  end

  # Private API

  @doc false
  defp do_generate_endpoint(protocol, uri, port, payload, @get_method) do
    params = URI.encode_query(payload)
    path = Constants.get_protocol_path()
    "#{protocol}://#{uri}#{port}/#{path}?#{params}"
  end

  defp do_generate_endpoint(protocol, uri, port, payload, @post_method) do
    params = URI.encode_query(payload)
    {vendor, version, ctype} = {
      Constants.post_protocol_vendor(),
      Constants.post_protocol_version(),
      Constants.post_content_type()
    }
    "#{protocol}://#{uri}#{port}/#{vendor}?#{version}"
  end

end
