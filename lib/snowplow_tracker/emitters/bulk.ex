defmodule SnowplowTracker.Emitters.Bulk do
  @moduledoc """
  This module defines the emitter that will buffer the events to be sent via
  POST requests. 
  """

  alias SnowplowTracker.Payload
  alias SnowplowTracker.Emitters.Cache

  @table Application.get_env(:snowplow_tracker, :table)

  def create(payload, url, table \\ @table) do
    eid =
      payload
      |> Payload.get()
      |> Map.fetch!("eid")

    Cache.insert({eid, payload, url}, table)
    {:ok, :success}
  end
end
