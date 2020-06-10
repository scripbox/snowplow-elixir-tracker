defmodule SnowplowTracker.Emitters.Server do
  @moduledoc """
  This module defines the genserver that will be responsible for scheduling the jobs to
  fetch events from ETS
  """

  use GenServer

  require Logger

  alias SnowplowTracker.Emitters.{Processor, Cache}

  def start_link(_args) do
    GenServer.start_link(
      __MODULE__,
      nil,
      name: __MODULE__
    )
  end

  def init(args) do
    state = %{
      type: args,
      data: nil
    }

    {:ok, state, {:continue, :cache_init}}
  end

  def handle_continue(:cache_init, state) do
    Cache.init()
    schedule_initial_job()
    {:noreply, state}
  end

  def handle_call(:delete, _from, state) do
    response = Cache.delete_table()
    {:reply, response, state}
  end

  def handle_info(:perform, state) do
    Processor.send()
    schedule_next_job()
    {:noreply, state}
  end

  def delete_table() do
    GenServer.call(__MODULE__, :delete)
  end

  defp schedule_initial_job() do
    Process.send_after(self(), :perform, initial_delay())
  end

  defp schedule_next_job() do
    Process.send_after(self(), :perform, next_delay())
  end

  defp server_config, do: Application.get_env(:snowplow_tracker, :emitters)[:server]

  defp initial_delay, do: server_config()[:initial_delay]

  defp next_delay, do: server_config()[:next_delay]
end
