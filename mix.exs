defmodule Ghost.MixProject do
  use Mix.Project

  def project do
    [
      app: :ghost,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Ghost",
      description: description(),
      source_url: "https://github.com/IBM/ghost",
      docs: [
        main: "Ghost", # The main page in the docs
        extras: ["README.md"]
      ],
      package: package()
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
      {:brod, "~> 3.0", optional: true},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "ghost",
      maintainers: ["Ethan Mahintorabi", "Evan Gordon"],
      # These are the default files included in the package
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/IBM/ghost"},
      source_url: "https://github.com/IBM/ghost"
    ]
  end

  defp description() do
    """
    A wrapper for Kafka clients that provies a testing sandbox implmentation for easier kafka tests.
    """
  end
end
