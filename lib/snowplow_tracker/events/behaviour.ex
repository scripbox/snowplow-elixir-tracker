defmodule SnowplowTracker.Events.Behaviour do
  @moduledoc """
  This module implements the behaviour for all events.
  """
  alias SnowplowTracker.Payload

  @doc """
  This function accepts a struct() object and validates the it's fields. If it is valid,
  it returns the object else it raises an appropriate error.
  """
  @callback validate(struct()) :: struct() | no_return()

  @doc """
  This function generates a map containing the key-value pairs for the event
  and returns a payload object.
  """
  @callback get(struct()) :: [Payload.t()]
end
