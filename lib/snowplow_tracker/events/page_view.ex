defmodule SnowplowTracker.Events.PageView do
  @moduledoc """
  This module implements the PageView event.
  """
  @behaviour SnowplowTracker.Events.Behaviour

  alias SnowplowTracker.{Errors, Constants, Payload, SelfDescribingJson}
  alias SnowplowTracker.Events.Helper

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
    timestamp: Helper.generate_timestamp(),
    # Optional
    event_id: Helper.generate_uuid(),
    # Optional
    true_timestamp: Helper.generate_timestamp(),
    # Optional
    contexts: []
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
      Constants.timestamp() => Helper.to_string(event.timestamp),
      Constants.eid() => event.event_id,
      Constants.true_timestamp() => Helper.to_string(event.true_timestamp)
    }
    |> (&Payload.add_map(%Payload{}, &1)).()
  end
end
