defmodule SnowplowTracker.Emitters.Bulk do
  @moduledoc """
  This module defines the genserver that will be responsible for scheduling the jobs to 
  fetch events from ETS
  """

  use GenServer

  require Logger

  alias SnowplowTracker.Emitters.{Processor, Cache}

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    schedule_initial_job()
    {:ok, nil}
  end

  def handle_info(:perform, state) do
    Processor.send()
    schedule_next_job()
    {:noreply, state}
  end

  def handle_call({:create, payload, url}, _from, state) do
    {:ok, msg} = Processor.insert(payload, url)
    Logger.log(:debug, "#{__MODULE__}: #{msg}")
    {:reply, {:ok, :success}, state}
  end

  defp schedule_initial_job() do
    # In 5 seconds
    Cache.init()
    Process.send_after(self(), :perform, 5_000)
  end

  defp schedule_next_job() do
    # In 60 seconds
    Process.send_after(self(), :perform, 60_000)
  end
end
