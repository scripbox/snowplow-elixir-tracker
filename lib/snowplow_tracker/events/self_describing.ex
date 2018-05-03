defmodule SnowplowTracker.Events.SelfDescribing do
  @moduledoc """
  This module implements the Self Describing event.
  """

  alias SnowplowTracker.{Constants, Payload, SelfDescribingJson}
  alias SnowplowTracker.Events.Helper, as: EventsHelper

  alias __MODULE__

  @enforce_keys [:event]

  @keys [
    # Required
    event: %SelfDescribingJson{},
    # Optional
    timestamp: EventsHelper.generate_timestamp(),
    # Optional
    event_id: EventsHelper.generate_uuid(),
    # Optional
    true_timestamp: EventsHelper.generate_timestamp(),
    # Optional
    contexts: []
  ]

  defstruct @keys

  @type t :: %__MODULE__{
          event: SelfDescribingJson.t(),
          timestamp: integer(),
          event_id: String.t(),
          true_timestamp: integer(),
          contexts: list(SelfDescribingJson.t())
        }

  @spec validate(t()) :: t()
  def validate(%SelfDescribing{} = event), do: event

  @spec get(%SelfDescribing{}, boolean()) :: Payload.t()
  def get(%SelfDescribing{} = sd_event, encode) do
    sdj = %SelfDescribingJson{
      schema: Constants.schema_unstruct_event(),
      data: SelfDescribingJson.get(sd_event.event)
    }

    %{
      Constants.event() => Constants.event_unstructured(),
      Constants.timestamp() => EventsHelper.to_string(sd_event.timestamp),
      Constants.eid() => sd_event.event_id,
      Constants.true_timestamp() => EventsHelper.to_string(sd_event.true_timestamp)
    }
    |> (&Payload.add_map(%Payload{}, &1)).()
    |> Payload.add_json(
      SelfDescribingJson.get(sdj),
      Constants.unstructured_encoded(),
      Constants.unstructured(),
      encode
    )
  end
end
