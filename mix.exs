defmodule Pdl.MixProject do
  use Mix.Project

  @source_url "https://github.com/paradox460/pdl"

  def project do
    [
      app: :pdl,
      version: "0.1.1",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      source_url: @source_url,
      homepage_url: @source_url,
      name: "Pdl",
      description: "A Process Dictionary based loader library",
      deps: deps(),
      package: package()
    ]
  end

  def package do
    [
      maintainers: ["Jeff Sandberg"],
      licenses: ["MIT"],
      links: %{
        GitHub: @source_url
      },
      files: ~w[
        lib
        test
        mix.exs
        README.md
        LICENSE
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
