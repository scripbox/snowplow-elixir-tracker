defmodule SnowplowTracker.Support.Payloads.Helper do
  @moduledoc false

  alias SnowplowTracker.Errors.InvalidParam

  @spec sanitize(any()) :: any() | no_return()
  def sanitize(param) when param == "" do
    raise InvalidParam, "empty string is not valid"
  end

  def sanitize(param), do: param

  @doc """
  This function is used to convert a map to a json string and encode it as base64 depending
  on the options passed.
  """
  @spec convert_to_json(map(), boolean()) :: String.t()
  def convert_to_json(map, true) do
    map
    |> Jason.encode!()
    |> Base.encode64()
  end

  def convert_to_json(map, false), do: Jason.encode!(map)
end
