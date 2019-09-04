defmodule SnowplowTracker.Emitters.Processor do
  @moduledoc """
  Processor module implementing the functions required for the bulk APIj
  """
  require Logger

  alias SnowplowTracker.{Constants, Errors, Payload, Request, Response}
  alias SnowplowTracker.Emitters.Cache

  @chunk_size 100
  @headers [Accept: Constants.post_content_type()]
  @options Application.get_env(:snowplow_tracker, :default_options) || []

  # Public API
  def send() do
    response = Cache.check_lock()
    do_send(response)
  end

  # Private API

  defp do_send([{_lock, _state}] = _response) do
    Logger.log(:error, "Lock not available")
  end

  defp do_send(_) do
    Cache.set_lock()
    |> process_events(Cache.match())
    |> Cache.release_lock()
  end

  defp process_events({:ok, _msg}, {:ok, data}) when length(data) >= 1 do
    [_, _, url] = data |> List.first()

    data
    |> Enum.chunk_every(@chunk_size)
    |> Enum.map(&create_payload/1)
    |> Enum.map(&send_request(&1, url))

    {:ok, :success}
  end

  defp process_events({:ok, _msg}, {:ok, data}) when length(data) == 0 do
    Logger.log(:debug, "#{__MODULE__}: No data available to process!")
    {:ok, :success}
  end

  defp process_events({:error, _msg}, {:ok, _data}) do
    Logger.log(:debug, "#{__MODULE__}: Skipping event processing!")
  end

  defp create_payload(events) when length(events) >= 1 do
    {payloads, keys} =
      Enum.map(events, fn [eid, payload, _url] ->
        {Payload.get(payload), eid}
      end)

    {:ok, encoded_payload} =
      Jason.encode(%{
        schema: Constants.schema_payload_data(),
        data: payloads
      })

    {:ok, encoded_payload, keys}
  end

  defp create_payload(_events), do: :ok

  defp send_request({:ok, payload_chunk, keys}, url) do
    with {:ok, response} <- Request.post(url, payload_chunk, @headers, @options),
         {:ok, body} <- Response.parse(response) do
      remove_processed_events(keys)
      {:ok, body}
    else
      {:error, error} ->
        raise Errors.ApiError, Kernel.inspect(error)
    end
  end

  defp send_request({_status, _payload_chunk, _keys}, _url) do
    raise Errors.EncodingError, "Failed to create JSON of payload chunk"
  end

  defp remove_processed_events(keys) do
    Enum.each(keys, fn [key, _, _] -> Cache.delete_key(key) end)
  end
end
