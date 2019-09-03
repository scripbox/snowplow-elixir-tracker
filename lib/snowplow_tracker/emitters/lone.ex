defmodule SnowplowTracker.Emitters.Lone do
  @moduledoc """
  This module defines the emitter that will process the GET requests. 
  """

  alias SnowplowTracker.{Request, Response, Errors}
  @options Application.get_env(:snowplow_tracker, :default_options) || []

  def create(_payload, url) do
    with {:ok, response} <- Request.get(url, [], @options),
         {:ok, body} <- Response.parse(response) do
      {:ok, body}
    else
      {:error, error} ->
        raise Errors.ApiError, Kernel.inspect(error)
    end
  end
end
