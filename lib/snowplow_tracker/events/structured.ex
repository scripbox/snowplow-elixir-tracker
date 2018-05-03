defmodule SnowplowTracker.Events.Structured do
  @moduledoc """
  This module implements the Structured event.
  """

  @behaviour SnowplowTracker.Events.Behaviour

  alias SnowplowTracker.{Errors, Constants, Payload, SelfDescribingJson}
  alias SnowplowTracker.Events.Helper, as: EventsHelper

  alias __MODULE__

  @enforce_keys [:category, :action]

  @keys [
    # Required
    :category,
    # Required
    :action,
    # Optional
    :label,
    # Optional
    :property,
    # Optional
    value: 0.0,
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
          category: String.t(),
          action: String.t(),
          label: String.t(),
          property: String.t(),
          value: float(),
          timestamp: integer(),
          event_id: String.t(),
          true_timestamp: integer(),
          contexts: list(SelfDescribingJson.t())
        }

  @spec validate(t()) :: t() | no_return()
  def validate(%Structured{category: ""}) do
    raise Errors.InvalidParam, "category cannot be blank"
  end

  def validate(%Structured{category: nil}) do
    raise Errors.InvalidParam, "category cannot be blank"
  end

  def validate(%Structured{action: ""}) do
    raise Errors.InvalidParam, "action cannot be blank"
  end

  def validate(%Structured{action: nil}) do
    raise Errors.InvalidParam, "action cannot be blank"
  end

  def validate(%Structured{} = event), do: event

  @spec get(t()) :: Payload.t()
  def get(%Structured{} = event) do
    %{
      Constants.event() => Constants.event_structured(),
      Constants.se_category() => event.category,
      Constants.se_action() => event.action,
      Constants.se_label() => event.label,
      Constants.se_property() => event.property,
      Constants.se_value() => EventsHelper.to_string(event.value),
      Constants.timestamp() => EventsHelper.to_string(event.timestamp),
      Constants.eid() => event.event_id,
      Constants.true_timestamp() => EventsHelper.to_string(event.true_timestamp)
    }
    |> (&Payload.add_map(%Payload{}, &1)).()
  end
end
