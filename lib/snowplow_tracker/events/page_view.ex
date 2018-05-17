defmodule SnowplowTracker.Events.PageView do
  @moduledoc """
  This module implements the PageView event.
  """
  @behaviour SnowplowTracker.Events.Behaviour

  alias SnowplowTracker.{Errors, Constants, Payload, SelfDescribingJson}
  alias SnowplowTracker.Events.Helper, as: EventsHelper

  alias __MODULE__

  @enforce_keys [:page_url]

  @keys [
    # Required
    :page_url,
    # Optional
    :page_title,
    # Optional
    :referrer,
    # Optional
    :timestamp,
    # Optional
    :event_id,
    # Optional
    :true_timestamp,
    # Optional
    :contexts
  ]

  @type t :: %__MODULE__{
          page_url: String.t(),
          page_title: String.t(),
          referrer: String.t(),
          timestamp: integer(),
          event_id: String.t(),
          true_timestamp: integer(),
          contexts: list(SelfDescribingJson.t())
        }

  defstruct @keys

  @spec new(map() | any()) :: t() | no_return()
  def new(data) when is_map(data) do
    %__MODULE__{
      page_url: Map.get(data, :page_url),
      page_title: Map.get(data, :page_title),
      timestamp: Map.get(data, :timestamp, EventsHelper.generate_timestamp()),
      event_id: Map.get(data, :event_id, EventsHelper.generate_uuid()),
      true_timestamp: Map.get(data, :true_timestamp, EventsHelper.generate_timestamp()),
      contexts: Map.get(data, :contexts, [])
    }
  end

  def new(data) do
    raise Errors.InvalidParam, "expected map, received #{data}"
  end

  @spec validate(t()) :: t() | no_return()
  def validate(%PageView{page_url: url}) when is_nil(url) or url == "" do
    raise Errors.InvalidParam, "page_url cannot be blank"
  end

  def validate(event), do: event

  @spec get(t()) :: Payload.t()
  def get(%PageView{} = event) do
    %{
      Constants.event() => Constants.event_page_view(),
      Constants.page_url() => event.page_url,
      Constants.page_title() => event.page_title,
      Constants.page_refr() => event.referrer,
      Constants.timestamp() => EventsHelper.to_string(event.timestamp),
      Constants.eid() => event.event_id,
      Constants.true_timestamp() => EventsHelper.to_string(event.true_timestamp)
    }
    |> (&Payload.add_map(%Payload{}, &1)).()
  end
end
