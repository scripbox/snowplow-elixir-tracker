defmodule SnowplowTracker.Payload do
  @moduledoc """
  Represents the data structure used to store event information
  """
  @derive Jason.Encoder

  alias __MODULE__

  alias SnowplowTracker.Support.Payloads.Helper

  @keys [pairs: %{}]

  defstruct @keys

  @type t :: %__MODULE__{
          pairs: map()
        }

  @doc """
  This function is used to add a key-value map to the payload object
  """
  @spec add(t, String.t() | Atom.t(), String.t() | Atom.t()) :: t
  def add(%Payload{} = payload, key, value) do
    {key, value} = {
      Helper.sanitize(key),
      Helper.sanitize(value)
    }

    payload
    |> Map.get(:pairs)
    |> Map.put(key, value)
    |> (&%Payload{pairs: &1}).()
  end

  @doc """
  This function is used to add a map containing one or many key-value pairs to a payload
  object.
  """
  @spec add_map(t, map()) :: t
  def add_map(%Payload{} = payload, map) do
    payload
    |> Map.get(:pairs)
    |> Map.merge(map)
    |> (&%Payload{pairs: &1}).()
  end

  @doc """
  This function is used convert a map to json, encode it as a base64 string depending on the
  `encode` flag and add it as a key-value pair to a payload object.
  """
  @spec add_json(t, map(), String.t(), String.t(), boolean()) :: t
  def add_json(payload, map, _, key_not_encoded, encode) when encode == false do
    map
    |> Helper.convert_to_json(encode)
    |> (&add(payload, key_not_encoded, &1)).()
  end

  def add_json(%Payload{} = payload, map, key_encoded, _, encode) when encode == true do
    map
    |> Helper.convert_to_json(encode)
    |> (&add(payload, key_encoded, &1)).()
  end

  @doc """
  This function is used to get the map containing key-value pairs stored in a payload object.
  """
  @spec get(t) :: map()
  def get(%Payload{} = payload), do: payload.pairs

  @doc """
  This function is used to convert a payload object to string and encode it to base64 depending
  on the `encode` flag.
  """
  @spec string(t, boolean()) :: t
  def string(%Payload{} = payload, encode), do: Helper.convert_to_json(payload.pairs, encode)
end
