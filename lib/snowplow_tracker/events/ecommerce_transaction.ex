defmodule SnowplowTracker.Events.EcommerceTransaction do
  @moduledoc """
  This module implements the Ecommerce Transaction event.
  """
  @behaviour SnowplowTracker.Events.Behaviour

  alias SnowplowTracker.{Errors, Constants, Payload, SelfDescribingJson}
  alias SnowplowTracker.Events.EcommerceTransactionItem
  alias SnowplowTracker.Events.Helper, as: EventsHelper

  alias __MODULE__

  @enforce_keys [:order_id, :total_value]

  @keys [
    # Required
    :order_id,
    # Required
    :total_value,
    # Optional
    :affiliation,
    # Optional
    :tax_value,
    # Optional
    :shipping,
    # Optional
    :city,
    # Optional
    :state,
    # Optional
    :country,
    # Optional
    :currency,
    # Optional
    :items,
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
          order_id: String.t(),
          total_value: float(),
          affiliation: String.t(),
          tax_value: float(),
          shipping: float(),
          city: String.t(),
          state: String.t(),
          country: String.t(),
          currency: String.t(),
          items: list(EcommerceTransactionItem.t()),
          timestamp: integer(),
          event_id: String.t(),
          true_timestamp: integer(),
          contexts: list(SelfDescribingJson.t())
        }

  # Public API

  @spec new(map() | any()) :: t() | no_return()
  def new(data) when is_map(data) do
    %__MODULE__{
      order_id: Map.get(data, :order_id),
      total_value: Map.get(data, :total_value),
      affiliation: Map.get(data, :affiliation),
      tax_value: Map.get(data, :tax_value),
      shipping: Map.get(data, :shipping),
      city: Map.get(data, :city),
      state: Map.get(data, :state),
      country: Map.get(data, :country),
      currency: Map.get(data, :currency),
      items: Map.get(data, :items),
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
  def validate(%EcommerceTransaction{order_id: ""}) do
    raise Errors.InvalidParam, "order_id cannot be blank"
  end

  def validate(%EcommerceTransaction{order_id: nil}) do
    raise Errors.InvalidParam, "order_id cannot be blank"
  end

  def validate(%EcommerceTransaction{total_value: nil}) do
    raise Errors.InvalidParam, "total_value cannot be nil"
  end

  def validate(event), do: event

  @spec get(t()) :: Payload.t()
  def get(%EcommerceTransaction{} = event) do
    %{
      Constants.event() => Constants.event_ecomm(),
      Constants.tr_id() => event.order_id,
      Constants.tr_total() => EventsHelper.to_string(event.total_value),
      Constants.tr_affiliation() => event.affiliation,
      Constants.tr_tax() => EventsHelper.to_string(event.tax_value),
      Constants.tr_shipping() => EventsHelper.to_string(event.shipping),
      Constants.tr_city() => event.city,
      Constants.tr_state() => event.state,
      Constants.tr_country() => event.country,
      Constants.tr_currency() => event.currency,
      Constants.timestamp() => EventsHelper.to_string(event.timestamp),
      Constants.eid() => event.event_id,
      Constants.true_timestamp() => EventsHelper.to_string(event.true_timestamp)
    }
    |> (&Payload.add_map(%Payload{}, &1)).()
  end
end
