defmodule SimpleRpc.MixProject do
  use Mix.Project

  @version "0.0.1-dev"

  def project do
    [
      app: :simple_rpc,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # hex
      description: "SimpleRpc",
      package: package(),

      # ex_doc
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/simple-rpc/sdk-elixir",
        "Changelog" => "https://github.com/simple-rpc/sdk-elixirc/blob/master/CHANGELOG.md"
      },
      maintainers: ["Chulki Lee"]
    ]
  end

  defp docs do
    [
      name: "ExVault",
      source_ref: "v#{@version}",
      canonical: "https://hexdocs.pm/simple_rpc",
      source_url: "https://github.com/simple-rpc/sdk-elixir"
    ]
  end
end
