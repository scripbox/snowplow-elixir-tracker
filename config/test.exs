use Mix.Config

config :snowplow_tracker,
  default_options: [
    timeout: 5000,
    recv_timeout: 2000
  ],
  table: :snowplow_events_test
