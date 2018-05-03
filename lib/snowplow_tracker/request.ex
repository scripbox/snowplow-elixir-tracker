defmodule SnowplowTracker.Request do
  @moduledoc """
  This module provides function to perform HTTP calls to the collector
  endpoint.
  """
  require HTTPoison

  use HTTPoison.Base
end
