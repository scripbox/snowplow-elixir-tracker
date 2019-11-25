defmodule SnowplowTracker.Application do
  use Application

  def start(_type, _args) do
    children =
      if Mix.env() != :test do
        [
          {SnowplowTracker.Emitters.Server, []}
        ]
      else
        []
      end

    Supervisor.start_link(children, strategy: :one_for_all)
  end
end
