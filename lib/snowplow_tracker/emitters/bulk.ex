defmodule SnowplowTracker.Emitters.Bulk do
  @moduledoc """
  This module defines the genserver that will be responsible for scheduling the jobs to 
  fetch events from ETS
  """

  use GenServer

  alias SnowplowTracker.Emitters.Processor
  @table Application.get_env(:snowplow_tracker, :table)

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    PersistentEts.new(
      @table,
      "#{Atom.to_string(@table)}.tab",
      [:named_table]
    )

    schedule_initial_job()
    {:ok, nil}
  end

  def handle_info(:perform, state) do
    Processor.send()
    schedule_next_job()
    {:noreply, state}
  end

  defp schedule_initial_job() do
    # In 5 seconds
    Process.send_after(self(), :perform, 5_000)
  end

  defp schedule_next_job() do
    # In 60 seconds
    Process.send_after(self(), :perform, 60_000)
  end

  def create(payload, url) do
    Processor.insert(payload, url)
  end
end
