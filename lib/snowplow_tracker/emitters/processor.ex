defmodule SnowplowTracker.Emitters.Processor do
  @moduledoc """
  Processor module implementing the functions required for the bulk API
  """
  require Logger

  alias SnowplowTracker.{Constants, Errors, Payload, Request, Response}
  alias SnowplowTracker.Emitters.Cache

  @chunk_size 100
  @headers [Accept: Constants.post_content_type()]
  @options Application.get_env(:snowplow_tracker, :default_options) || []
  @table Application.get_env(:snowplow_tracker, :table)

  # Public API
  def send(table \\ @table) do
    table
    |> Cache.check_lock()
    |> do_send(table)
  end

  # Private API

  defp do_send([{_lock, _state}] = _response, _table) do
    Logger.log(:error, "Lock not available")
  end

  defp do_send(_, table) do
    Cache.set_lock(table)
    |> process_events(Cache.match(table), table)
    |> Cache.release_lock(table)
  end

  defp process_events({:ok, _msg}, {:ok, data}, table) when length(data) >= 1 do
    [_, _, url] = data |> List.first()

    data
    |> Enum.chunk_every(@chunk_size)
    |> Enum.map(&create_payload/1)
    |> Enum.map(&send_request(&1, url, table))

    {:ok, :success}
  end

  defp process_events({:ok, _msg}, {:ok, data}, _table) when length(data) == 0 do
    Logger.log(:debug, "#{__MODULE__}: No data available to process!")
    {:ok, :success}
  end

  defp process_events({:error, _msg}, {:ok, _data}, _table) do
    Logger.log(:debug, "#{__MODULE__}: Skipping event processing!")
  end

  defp create_payload(events) when length(events) >= 1 do
    events_map =
      events
      |> Enum.map(fn [eid, payload, _url] ->
        {eid, Payload.get(payload)}
      end)
      |> Map.new()

    {:ok, encoded_payload} =
      Jason.encode(%{
        schema: Constants.schema_payload_data(),
        data: Map.values(events_map)
      })

    {:ok, encoded_payload, Map.keys(events_map)}
  end

  defp create_payload(_events), do: :ok

  defp send_request({:ok, payload_chunk, keys}, url, table) do
    with {:ok, response} <- Request.post(url, payload_chunk, @headers, @options),
         {:ok, body} <- Response.parse(response) do
      remove_processed_events(keys, table)
      {:ok, body}
    else
      {:error, error} ->
        raise Errors.ApiError, Kernel.inspect(error)
    end
  end

  defp send_request({_status, _payload_chunk, _keys}, _url, _table) do
    raise Errors.EncodingError, "Failed to create JSON of payload chunk"
  end

  defp remove_processed_events(keys, table) do
    Enum.each(keys, fn key -> Cache.delete_key(key, table) end)
  end
end
