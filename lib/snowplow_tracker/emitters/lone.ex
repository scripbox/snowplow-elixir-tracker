defmodule SnowplowTracker.Emitters.Lone do
  @moduledoc """
  This module defines the emitter that will process the GET requests. 
  """

  alias SnowplowTracker.{Request, Response, Errors}

  def create(payload, url, options) do
    with {:ok, response} <- Request.get(url, [], options),
         {:ok, body} <- Response.parse(response) do
      {:ok, body}
    else
      {:error, error} ->
        raise Errors.ApiError, Kernel.inspect(error)
    end
  end
end
