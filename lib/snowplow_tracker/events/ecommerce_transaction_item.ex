defmodule SnowplowTracker.Events.EcommerceTransactionItem do
  @moduledoc """
  This module implement the Ecommerce Trasaction Item event
  """

  alias SnowplowTracker.{Errors, Constants, Payload, SelfDescribingJson}
  alias SnowplowTracker.Support.Events.Helper, as: EventsHelper

  alias __MODULE__

  @keys [
    # Required
    :sku,
    # Required
    :price,
    # Required
    :quantity,
    # Optional
    :name,
    # Optional
    :category,
    # Optional
    :event_id,
    # Optional
    :contexts
  ]

  defstruct @keys

  @type t :: %__MODULE__{
          sku: String.t(),
          price: float(),
          quantity: integer(),
          name: String.t(),
          category: String.t(),
          event_id: String.t(),
          contexts: list(SelfDescribingJson.t())
        }

  @spec new(map() | any()) :: t() | no_return()
  def new(data) when is_map(data) do
    %__MODULE__{
      sku: Map.get(data, :sku),
      price: Map.get(data, :price),
      quantity: Map.get(data, :quantity),
      name: Map.get(data, :name),
      category: Map.get(data, :category),
      event_id: Map.get(data, :event_id, EventsHelper.generate_uuid()),
      contexts: Map.get(data, :contexts, [])
    }
  end

  def new(data) do
    raise Errors.InvalidParam, "expected map, received #{data}"
  end

  @spec validate(t()) :: t() | no_return()
  def validate(%EcommerceTransactionItem{sku: ""}) do
    raise Errors.InvalidParam, "sku cannot be empty"
  end

  def validate(%EcommerceTransactionItem{sku: nil}) do
    raise Errors.InvalidParam, "sku cannot be nil"
  end

  def validate(%EcommerceTransactionItem{price: nil}) do
    raise Errors.InvalidParam, "price cannot be nil"
  end

  def validate(%EcommerceTransactionItem{quantity: nil}) do
    raise Errors.InvalidParam, "quantity cannot be nil"
  end

  def validate(event), do: event

  @spec get(t(), String.t(), String.t()) :: Payload.t()
  def get(%EcommerceTransactionItem{} = event, order_id, currency) do
    %{
      Constants.event() => Constants.event_ecomm_item(),
      Constants.ti_item_id() => order_id,
      Constants.ti_item_currency() => currency,
      Constants.ti_item_sku() => event.sku,
      Constants.ti_item_price() => EventsHelper.to_string(event.price),
      Constants.ti_item_quantity() => EventsHelper.to_string(event.quantity),
      Constants.ti_item_name() => event.name,
      Constants.ti_item_category() => event.category,
      Constants.eid() => event.event_id
    }
    |> (&Payload.add_map(%Payload{}, &1)).()
  end
end
