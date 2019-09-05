defmodule SnowplowTracker.Emitters.Bulk do
  @moduledoc """
  This module defines the emitter that will buffer the events to be sent via
  POST requests. 
  """

  alias SnowplowTracker.Payload
  alias SnowplowTracker.Emitters.Server

  def create(payload, url) do
    eid =
      payload
      |> Payload.get()
      |> Map.fetch!("eid")

    Server.insert({eid, payload, url})
  end
end
