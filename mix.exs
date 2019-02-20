defmodule SnowplowTracker.MixProject do

  use Mix.Project

  def project do
    [
      app: :snowplow_tracker,
      version: "1.0.0",
      elixir: "~> 1.8.1",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "snowplow_tracker",
      source_url: "https://github.com/scripbox/snowplow-elixir-tracker"
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
      {:mock, "~> 0.3.0", only: :test}
    ]
  end

  def description() do
    "Snowplow event tracker for elixir. Add analytics to all your elixir apps"
  end

  defp package() do
    [
      maintainers: ["Shubham Gupta"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/scripbox/snowplow-elixir-tracker"}
    ]
  end
end
