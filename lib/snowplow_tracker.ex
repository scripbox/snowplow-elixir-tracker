defmodule SnowplowTracker do
  @moduledoc """
  Module is used to track events and send them to snowplow
  """
  alias SnowplowTracker.{
    Emitter,
    Tracker,
    Payload,
    Events,
    Helper
  }

  # Private API

  @doc false
  @spec track(Payload.t(), Tracker.t(), list()) :: {:ok, String.t()} | no_return()
  defp track(%Payload{} = payload, %Tracker{} = tracker, contexts \\ []) do
    tracker = Tracker.validate(tracker)

    payload
    |> Helper.add_data(tracker, contexts)
    |> Emitter.input(tracker.emitter)
  end

  # Public API

  @doc """
  This function is used to track a PageView event.
  """
  @spec track_page_view(Events.PageView.t(), Tracker.t(), module()) ::
          {:ok, String.t()} | no_return()
  def track_page_view(%Events.PageView{} = event, %Tracker{} = tracker, module \\ Events.PageView) do
    event
    |> module.validate()
    |> module.get()
    |> track(tracker, event.contexts)
  end

  @doc """
  This function is used to track a Structured event.
  """
  @spec track_struct_event(Events.Structured.t(), Tracker.t(), module()) ::
          {:ok, String.t()} | no_return()
  def track_struct_event(
        %Events.Structured{} = event,
        %Tracker{} = tracker,
        module \\ Events.Structured
      ) do
    event
    |> module.validate()
    |> module.get()
    |> track(tracker, event.contexts)
  end

  @doc """
  This function is used to track a SelfDescribing event.
  """
  @spec track_self_describing_event(Events.SelfDescribing.t(), Tracker.t(), module()) ::
          {:ok, String.t()} | no_return()
  def track_self_describing_event(
        %Events.SelfDescribing{} = event,
        %Tracker{} = tracker,
        module \\ Events.SelfDescribing
      ) do
    event
    |> module.validate()
    |> module.get(tracker.base64_encode)
    |> track(tracker, event.contexts)
  end

  @doc """
  This function is used to track a ScreenView event.
  """
  @spec track_screen_view(Events.ScreenView.t(), Tracker.t(), module()) ::
          {:ok, String.t()} | no_return()
  def track_screen_view(
        %Events.ScreenView{} = event,
        %Tracker{} = tracker,
        module \\ Events.ScreenView
      ) do
    event
    |> module.validate()
    |> module.get()
    |> track(tracker, event.contexts)
  end

  @doc """
  This function is used to track a Timing event.
  """
  @spec track_timing(Events.Timing.t(), Tracker.t(), module()) :: {:ok, String.t()} | no_return()
  def track_timing(%Events.Timing{} = event, %Tracker{} = tracker, module \\ Events.Timing) do
    event
    |> module.validate()
    |> module.get()
    |> track(tracker, event.contexts)
  end

  @doc """
  This function is used to track a EcommerceTransaction event.
  """
  @spec track_ecommerce_transaction(Events.EcommerceTransaction.t(), Tracker.t(), module()) ::
          {:ok, String.t()} | no_return()
  def track_ecommerce_transaction(
        %Events.EcommerceTransaction{} = event,
        %Tracker{} = tracker,
        module \\ Events.EcommerceTransaction
      ) do
    event
    |> module.validate()
    |> module.get()
    |> track(tracker, event.contexts)
  end

  @doc """
  This function is used to track a EcommerceTransactionItem event.
  """
  @spec track_ecommerce_transaction_item(
          Events.EcommerceTransactionItem.t(),
          Tracker.t(),
          module()
        ) :: {:ok, String.t()} | no_return()
  def track_ecommerce_transaction_item(
        %Events.EcommerceTransactionItem{} = event,
        %Tracker{} = tracker,
        module \\ Events.EcommerceTransactionItem
      ) do
    event
    |> module.validate()
    |> module.get()
    |> track(tracker, event.contexts)
  end
end
