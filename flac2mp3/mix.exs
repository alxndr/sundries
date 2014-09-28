defmodule Flac2mp3.Mixfile do
  use Mix.Project

  def project do
    [app: :flac2mp3,
     version: "0.0.1",
     elixir: "~> 1.0.0",
     deps: deps,
     escript: escript]
  end

  defp escript do
    [main_module: Flac2mp3.CLI]
  end

  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end
end
