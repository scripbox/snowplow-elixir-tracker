defmodule SnowplowTracker.Emitters.Bulk do
  @moduledoc """
  This module defines the emitter that will buffer the events to be sent via
  POST requests. 
  """

  alias SnowplowTracker.Emitters.Cache
  alias SnowplowTracker.Payload

  @options Application.get_env(:snowplow_tracker, :default_options) || []

  def create(payload, url) do
    eid =
      payload
      |> Payload.get()
      |> Map.fetch!("eid")

    Cache.insert({eid, payload, url})
  end
end
