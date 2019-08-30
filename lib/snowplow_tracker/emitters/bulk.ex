defmodule SnowplowTracker.Emitters.Bulk do
  @moduledoc """
  This module defines the emitter that will process the GET requests. 
  """

  use GenServer

  alias :ets, as: Ets
  alias SnowplowTracker.{Request, Response, Errors}
  @table Application.get_env(:snowplow_tracker, :table_name)

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    schedule_initial_job()
    {:ok, nil}
  end

  def handle_info(:perform, state) do
    # Perform job
    {keys, payloads, urls} = Ets.match(@table, {:"$1", :"$2", :"$3"})
    # Create post payload
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

  def create(payload, url, _options) do
    eid = Map.get(payload, :eid)

    Ets.insert(
      @table,
      {eid, payload, url}
    )

    {:ok, "Insert successful"}
  end
end
