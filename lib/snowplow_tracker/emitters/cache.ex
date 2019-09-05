defmodule SnowplowTracker.Emitters.Cache do
  @moduledoc """
  Module which implements functions to interact with ETS
  """

  require Logger

  alias :ets, as: Ets

  @table Application.get_env(:snowplow_tracker, :table)
  @lock "lock"

  def init(table \\ @table) do
    response =
      PersistentEts.new(
        table,
        "#{Atom.to_string(table)}.tab",
        [:named_table]
      )

    case response do
      {:error, _} ->
        Logger.log(:debug, "Failed to create table #{table}!")
        {:error, :failed}

      _ ->
        Logger.log(:debug, "Table #{table} created successfully!")
        {:ok, :success}
    end
  end

  def insert(payload, table \\ @table) do
    Ets.insert(table, payload)
    {:ok, :success}
  end

  def match(table \\ @table) do
    {
      :ok,
      Ets.match(table, {:"$1", :"$2", :"$3"})
    }
  end

  def check_lock(table \\ @table) do
    {
      :ok,
      Ets.lookup(table, @lock)
    }
  end

  def release_lock(payload, table \\ @table)

  def release_lock({:ok, _msg}, table), do: delete_key(@lock, table)

  def release_lock({:error, _}, _table), do: :ok

  def set_lock(table \\ @table) do
    try do
      Ets.insert(table, {@lock, true})
      Logger.log(:debug, "#{__MODULE__}: Lock set successfully!")
      {:ok, :success}
    rescue
      _e in ArgumentError ->
        Logger.log(:debug, "#{__MODULE__}: Falied to set lock!")
        {:error, :failed}
    end
  end

  def delete_key(key, table \\ @table) do
    Ets.delete(table, key)
    Logger.log(:debug, "Key deleted: #{key}")
    {:ok, :success}
  end

  def delete_table(table \\ @table) do
    Ets.delete(table)
  end
end
