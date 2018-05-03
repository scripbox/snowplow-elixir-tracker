defmodule SnowplowTracker.Tracker do
  @moduledoc """
  This module defines the structure for the Tracker.
  """
  alias SnowplowTracker.{Payload, Emitter, Errors, Subject, Events}

  alias __MODULE__

  @keys [
    emitter: %Emitter{},
    subject: %Subject{},
    namespace: nil,
    app_id: nil,
    platform: "srv",
    base64_encode: true
  ]

  defstruct @keys

  @type t :: %__MODULE__{
          emitter: %Emitter{},
          subject: Subject.t(),
          namespace: String.t(),
          app_id: String.t(),
          platform: String.t(),
          base64_encode: boolean()
        }

  # Public API

  @doc """
  This function is used to validate the tracker and it's contents.
  If the tracker is valid the object is returned else an error is
  raised in any of the required fields are missing.
  """
  def validate(%Tracker{emitter: nil}) do
    raise Errors.InvalidParam, "emitter cannot be nil"
  end

  def validate(%Tracker{subject: nil}) do
    raise Errors.InvalidParam, "subject cannot be nil"
  end

  def validate(%Tracker{base64_encode: base}) when not is_boolean(base) do
    raise Errors.InvalidParam, "base64_encode should be boolean"
  end

  def validate(tracker), do: tracker
end
