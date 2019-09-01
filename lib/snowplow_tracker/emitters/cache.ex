defmodule SnowplowTracker.Emitters.Cache do
  @moduledoc """
  Module which implements functions to interact with ETS
  """

  require Logger

  alias :ets, as: Ets

  @table Application.get_env(:snowplow_tracker, :table)
  @lock "lock"

  def init() do
    PersistentEts.new(
      @table,
      "#{Atom.to_string(@table)}.tab",
      [:named_table]
    )

    {:ok, :success}
  end

  def insert(payload) do
    Ets.insert(@table, payload)
    {:ok, :success}
  end

  def match() do
    {
      :ok,
      Ets.match(@table, {:"$1", :"$2", :"$3"})
    }
  end

  def check_lock() do
    {
      :ok,
      Ets.lookup(@table, @lock)
    }
  end

  def release_lock() do
    delete_key(@lock)
  end

  def set_lock() do
    Ets.insert(@table, {@lock, true})
    Logger.log(:debug, "#{__MODULE__}: Lock set successfully!")
    {:ok, :success}
  end

  def delete_key(key) do
    Ets.delete(@table, key)
    Logger.log(:debug, "Key deleted: #{key}")
    {:ok, :success}
  end
end
