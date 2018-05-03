defmodule SnowplowTracker.Events.Timing do
  @moduledoc """
  This module implements the Timing event
  """

  @behaviour SnowplowTracker.Events.Behaviour

  alias SnowplowTracker.{Errors, Constants, SelfDescribingJson}
  alias SnowplowTracker.Events.SelfDescribing
  alias SnowplowTracker.Events.Helper, as: EventsHelper

  alias __MODULE__

  @enforce_keys [:category, :variable, :timing]

  @keys [
    # Required
    :category,
    # Required
    :variable,
    # Required
    :timing,
    # Optional
    :label,
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
          variable: String.t(),
          timing: integer(),
          label: String.t(),
          timestamp: integer(),
          event_id: String.t(),
          true_timestamp: integer(),
          contexts: list(%SelfDescribingJson{})
        }

  @spec validate(t()) :: t() | no_return()
  def validate(%Timing{category: ""}) do
    raise Errors.InvalidParam, "category cannot be blank"
  end

  def validate(%Timing{category: nil}) do
    raise Errors.InvalidParam, "category cannot be blank"
  end

  def validate(%Timing{variable: ""}) do
    raise Errors.InvalidParam, "variable cannot be blank"
  end

  def validate(%Timing{variable: nil}) do
    raise Errors.InvalidParam, "variable cannot be blank"
  end

  def validate(%Timing{timing: nil}) do
    raise Errors.InvalidParam, "timing cannot be blank"
  end

  def validate(%Timing{} = event), do: event

  @spec get(t()) :: SelfDescribing.t()
  def get(%Timing{} = event) do
    sdj = %SelfDescribingJson{
      schema: Constants.schema_user_timings(),
      data: %{
        Constants.ut_category() => event.category,
        Constants.ut_variable() => event.variable,
        Constants.ut_timing() => event.timing,
        Constants.ut_label() => event.label
      }
    }

    %SelfDescribing{
      event: sdj,
      timestamp: event.timestamp,
      event_id: event.event_id,
      true_timestamp: event.true_timestamp,
      contexts: event.contexts
    }
  end
end
