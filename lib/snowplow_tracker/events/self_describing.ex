defmodule SnowplowTracker.Events.SelfDescribing do
  @moduledoc """
  This module implements the Self Describing event.
  """

  alias SnowplowTracker.{Errors, Constants, Payload, SelfDescribingJson}
  alias SnowplowTracker.Support.Events.Helper, as: EventsHelper

  alias __MODULE__

  @enforce_keys [:event]

  @keys [
    # Required
    :event,
    # Optional
    :timestamp,
    # Optional
    :event_id,
    # Optional
    :true_timestamp,
    # Optional
    :contexts
  ]

  defstruct @keys

  @type t :: %__MODULE__{
          event: SelfDescribingJson.t(),
          timestamp: integer(),
          event_id: String.t(),
          true_timestamp: integer(),
          contexts: list(SelfDescribingJson.t())
        }

  @spec new(map() | any()) :: t() | no_return()
  def new(data) when is_map(data) do
    %__MODULE__{
      event: Map.get(data, :event, %SelfDescribingJson{}),
      timestamp: Map.get(data, :timestamp, EventsHelper.generate_timestamp()),
      event_id: Map.get(data, :event_id, EventsHelper.generate_uuid()),
      true_timestamp: Map.get(data, :true_timestamp, EventsHelper.generate_timestamp()),
      contexts: Map.get(data, :contexts, [])
    }
  end

  def new(data) do
    raise Errors.InvalidParam, "expected map, received #{data}"
  end

  @spec validate(t()) :: t()
  def validate(%SelfDescribing{} = event), do: event

  @spec get(%SelfDescribing{}, boolean()) :: Payload.t()
  def get(%SelfDescribing{} = sd_event, encode) do
    %{
      Constants.event() => Constants.event_unstructured(),
      Constants.timestamp() => EventsHelper.to_string(sd_event.timestamp),
      Constants.eid() => sd_event.event_id,
      Constants.true_timestamp() => EventsHelper.to_string(sd_event.true_timestamp)
    }
    |> (&Payload.add_map(%Payload{}, &1)).()
    |> Payload.add_json(
      sd_event.event,
      Constants.unstructured_encoded(),
      Constants.unstructured(),
      encode
    )
  end
end
