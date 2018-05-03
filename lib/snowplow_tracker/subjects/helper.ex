defmodule SnowplowTracker.Subjects.Helper do
  @moduledoc """
  This module contains helper functions to support 'Subject' type creation.
  """

  alias SnowplowTracker.Errors

  @supported_platforms [
    "pc",
    "tv",
    "mob",
    "cnsl",
    "iot",
    "web",
    "srv",
    "app"
  ]

  @doc """
  This function validates if the specified platform type is valid or not

  Raise an InvalidParam error if the platform is not valid, returns `:ok` otherwise

  ## Examples

      iex> SnowplowTracker.Subjects.Helper.validate_platform("srv")
      :ok

  """
  @spec validate_platform(String.t()) :: String.t() | no_return()
  def validate_platform(platform) do
    if Enum.member?(@supported_platforms, platform) do
      platform
    else
      raise Errors.InvalidParam, "specified platform is not supported"
    end
  end
end
