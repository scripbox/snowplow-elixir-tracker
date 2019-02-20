defmodule SnowplowTracker.Errors.NotImplemented do
  # --skip--
  defexception [:reason]

  def exception(reason), do: %__MODULE__{reason: reason}

  def message(%__MODULE__{reason: reason}), do: "SnowplowTracker::NotImplemented - #{reason}"
end

defmodule SnowplowTracker.Errors.ApiError do
  defexception [:reason]

  def exception(reason), do: %__MODULE__{reason: reason}

  def message(%__MODULE__{reason: reason}), do: "SnowplowTracker::ApiError - #{reason}"
end

defmodule SnowplowTracker.Errors.InvalidParam do
  defexception [:reason]

  def exception(reason), do: %__MODULE__{reason: reason}

  def message(%__MODULE__{reason: reason}), do: "SnowplowTracker::InvalidParam - #{reason}"
end
