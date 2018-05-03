defmodule SnowplowTracker.Events.EventMock do
  require SnowplowTracker.Payload

  alias SnowplowTracker.Payload

  def validate(event) do
    send(self(), {:ok, "validated"})
    event
  end

  def get(_) do
    send(self(), {:ok, "successful"})
    Payload.add(%Payload{}, :test, :value)
  end

  def get(_, _) do
    send(self(), {:ok, "successful"})
    Payload.add(%Payload{}, :test, :value)
  end
end
