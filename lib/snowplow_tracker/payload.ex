defmodule SnowplowTracker.Payload do
  @moduledoc """
  Represents the data structure used to store event information
  """
  @derive Jason.Encoder

  alias __MODULE__

  alias SnowplowTracker.Payloads.Helper

  @keys [
    pairs: %{}
  ]

  defstruct @keys

  @type t :: %__MODULE__{
          pairs: map()
        }


  def new(payload) do
    struct(__MODULE__, pairs: payload["pairs"])
  end

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

  @doc """
  Decode the JSON payload storing the original json as part of the struct.
  """
  @spec decode(binary) :: {:ok, %__MODULE__{}} | {:error, Jason.DecodeError.t()}
  def decode(json_payload) do
    case Jason.decode(json_payload) do
      {:ok, response} ->
        __MODULE__.new(response)

      {:error, error} ->
        {:error, error}

      {:error, :invalid, pos} ->
        {:error, "Invalid json at position: #{pos}"}
    end
  end

  @doc """
  Decode the JSON payload storing the original json as part of the struct, raising if there is an error
  """
  @spec decode!(binary) :: %__MODULE__{}
  def decode!(payload) do
    payload
    |> Jason.decode!()
    |> __MODULE__.new(response)
  end
end
