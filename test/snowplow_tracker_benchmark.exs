alias SnowplowTracker
alias SnowplowTracker.Events.Structured
alias SnowplowTracker.{Tracker, Emitter}

:hackney_pool.child_spec(:snowplow_hackney_pool, timeout: 60_000, max_connections: 500)
emitter = %Emitter{collector_uri: "locahost", protocol: "http", request_type: "GET" }
tracker = %Tracker{emitter: emitter}
payload = Structured.new(%{category: "test", action: "test", value: 0.0})


tracker_func = fn _ -> SnowplowTracker.track_struct_event(payload, tracker) end
Benchee.run(
  %{
    "structured event" => fn -> (1..100000) |>  Enum.each(tracker_func) end
  },
  formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ],
  time: 15,
  warmup: 5,
  parallel: 12
)

