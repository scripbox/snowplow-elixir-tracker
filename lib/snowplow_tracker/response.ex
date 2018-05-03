defmodule SnowplowTracker.Response do
  @moduledoc """
  This module is used to parse the response received after sending the
  event to the collector
  """

  @doc """
  This function is used to parse the response. Depending on the status code
  and the type of response it will return the body.
  """
  @spec parse(%HTTPoison.Response{}) :: {:ok, String.t()} | {:error, String.t()}
  def parse(%HTTPoison.Response{} = response) do
    case response do
      %HTTPoison.Response{status_code: 200, body: body} ->
        {:ok, body}

      %HTTPoison.Response{status_code: status_code, body: body} ->
        {:error, "#{status_code} - #{body}"}
    end
  end

  def parse(_response) do
    {:error, "Invalid response"}
  end
end
