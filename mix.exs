defmodule FactoryGirlElixir.Mixfile do
  use Mix.Project

  def project do
    [app: :factory_girl_elixir,
     version: "0.1.1",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [],
     mod: {FactoryGirlElixir, []}]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end

  defp description do
    """
    Minimal implementation of Ruby's factory_girl in Elixir.
    """
  end

  defp package do
    [contributors: ["Duilio Ruggiero"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/sinetris/factory_girl_elixir"}]
  end
end
