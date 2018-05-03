defmodule SnowplowTracker.Subject do
  @moduledoc """
  This module describes the structure for the Subject which stores meta
  information about the event.
  """
  alias SnowplowTracker.{Payload, Constants}

  alias SnowplowTracker.Subjects.Helper

  alias __MODULE__

  @keys [
    payload: %Payload{}
  ]

  defstruct @keys

  @type t :: %__MODULE__{
          payload: Payload.payload_type()
        }

  # Private API
  defp set_parameter(subject, key, value) do
    subject.payload
    |> Payload.add(key, value)
    |> (&put_in(subject.payload, &1)).()
  end

  # Public API
  @spec set_user_id(t(), String.t()) :: String.t()
  def set_user_id(%Subject{} = subject, user_id) do
    set_parameter(
      subject,
      Constants.uid(),
      user_id
    )
  end

  @spec set_screen_resolution(t(), integer(), integer()) :: t()
  def set_screen_resolution(%Subject{} = subject, width, height) do
    resolution = "#{width}x#{height}"

    set_parameter(
      subject,
      Constants.resolution(),
      resolution
    )
  end

  @spec set_viewport(t(), integer(), integer()) :: t()
  def set_viewport(%Subject{} = subject, width, height) do
    viewport = "#{width}x#{height}"

    set_parameter(
      subject,
      Constants.viewport(),
      viewport
    )
  end

  @spec set_platform(t(), integer()) :: t()
  def set_color_depth(%Subject{} = subject, depth) do
    set_parameter(
      subject,
      Constants.color_depth(),
      depth
    )
  end

  @spec set_timezone(t(), String.t()) :: t()
  def set_timezone(%Subject{} = subject, timezone) do
    set_parameter(
      subject,
      Constants.timezone(),
      timezone
    )
  end

  @spec set_platform(t(), String.t()) :: t()
  def set_platform(%Subject{} = subject, platform) do
    platform
    |> Helper.validate_platform()
    |> (&set_parameter(
          subject,
          Constants.platform(),
          &1
        )).()
  end

  @spec set_language(t(), String.t()) :: t()
  def set_language(%Subject{} = subject, language) do
    set_parameter(
      subject,
      Constants.language(),
      language
    )
  end

  @spec set_ip_address(t(), String.t()) :: t()
  def set_ip_address(%Subject{} = subject, addr) do
    set_parameter(
      subject,
      Constants.ip_address(),
      addr
    )
  end

  @spec set_user_agent(t(), String.t()) :: t()
  def set_user_agent(%Subject{} = subject, user_agent) do
    set_parameter(
      subject,
      Constants.useragent(),
      user_agent
    )
  end

  @spec set_domain_user_id(t(), String.t()) :: t()
  def set_domain_user_id(%Subject{} = subject, uid) do
    set_parameter(
      subject,
      Constants.domain_uid(),
      uid
    )
  end

  @spec set_network_user_id(t(), String.t()) :: t()
  def set_network_user_id(%Subject{} = subject, nuid) do
    set_parameter(
      subject,
      Constants.network_uid(),
      nuid
    )
  end

  @spec get(t()) :: map()
  def get(%Subject{} = subject), do: Payload.get(subject.payload)
end
