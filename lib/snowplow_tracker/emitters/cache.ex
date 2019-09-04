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

  def release_lock({:ok, _msg}), do: delete_key(@lock)

  def release_lock({:error, _}), do: :ok

  def set_lock() do
    response = Ets.insert(@table, {@lock, true})

    case response do
      true ->
        Logger.log(:debug, "#{__MODULE__}: Lock set successfully!")
        {:ok, :success}

      _ ->
        Logger.log(:debug, "#{__MODULE__}: Falied to set lock!")
        {:error, :failed}
    end
  end

  def delete_key(key) do
    Ets.delete(@table, key)
    Logger.log(:debug, "Key deleted: #{key}")
    {:ok, :success}
  end
end
