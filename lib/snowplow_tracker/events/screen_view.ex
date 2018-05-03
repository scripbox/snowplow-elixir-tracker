defmodule SnowplowTracker.Events.ScreenView do
  @moduledoc """
  This module implements the ScreenView event.
  """

  @behaviour SnowplowTracker.Events.Behaviour

  alias SnowplowTracker.{Errors, Constants, Payload, SelfDescribingJson}
  alias SnowplowTracker.Events.SelfDescribing
  alias SnowplowTracker.Events.Helper, as: EventsHelper

  alias __MODULE__

  @keys [
    # Optional
    :name,
    # Optional
    :id,
    # Optional
    timestamp: EventsHelper.generate_timestamp(),
    # Optional
    event_id: EventsHelper.generate_uuid(),
    # Optional
    true_timestamp: EventsHelper.generate_timestamp(),
    # Optional
    contexts: []
  ]

  @type t :: %__MODULE__{
          name: String.t(),
          id: String.t(),
          timestamp: integer(),
          event_id: String.t(),
          true_timestamp: integer(),
          contexts: list(SelfDescribingJson.t())
        }

  defstruct @keys

  @spec validate(t()) :: t() | no_return()
  def validate(%ScreenView{name: nil, id: nil}) do
    raise Errors.InvalidParam, "name and id both cannot be blank"
  end

  def validate(%ScreenView{name: "", id: ""}) do
    raise Errors.InvalidParam, "name and id both cannot be blank"
  end

  def validate(%ScreenView{name: nil, id: ""}) do
    raise Errors.InvalidParam, "name and id both cannot be blank"
  end

  def validate(%ScreenView{name: "", id: nil}) do
    raise Errors.InvalidParam, "name and id both cannot be blank"
  end

  def validate(%ScreenView{} = event), do: event

  @spec get(t()) :: Payload.t()
  def get(%ScreenView{} = event) do
    sdj =
      %{
        Constants.sv_name() => event.name,
        Constants.sv_id() => event.id
      }
      |> (&Payload.add_map(%Payload{}, &1)).()
      |> (&%SelfDescribingJson{
            schema: Constants.schema_screen_view(),
            data: Payload.get(&1)
          }).()

    %SelfDescribing{
      event: sdj,
      timestamp: EventsHelper.to_string(event.timestamp),
      event_id: event.event_id,
      true_timestamp: EventsHelper.to_string(event.true_timestamp),
      contexts: event.contexts
    }
  end
end
