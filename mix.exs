defmodule SnowplowTracker.MixProject do
  use Mix.Project

  def project do
    [
      app: :snowplow_tracker,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.1"},
      {:jason, "~> 1.0"},
      {:uuid, "~> 1.1"},
      {:ex_doc, "~> 0.11", only: :dev},
      {:mock, "~> 0.3.0", only: :test},
      {:excoveralls, "~> 0.8", only: :test}
    ]
  end
end
