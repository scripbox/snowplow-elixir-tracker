defmodule SnowplowTracker.SelfDescribingJson do
  @moduledoc """
  This module implements the structure for the Self Describing JSON
  type.
  """
  @derive Jason.Encoder

  alias __MODULE__

  @keys [
    :schema,
    :data
  ]

  defstruct @keys

  @type t :: %__MODULE__{
          schema: String.t(),
          data: map()
        }

  @doc """
  This function encodes the given object as a json string and returns it.
  """
  @spec get(t) :: String.t()
  def get(%SelfDescribingJson{} = event), do: Jason.encode!(event)
end
