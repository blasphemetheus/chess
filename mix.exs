defmodule Genomeur.Mix do
  use Mix.Project

  def project do
    [
      app: :genomeur,
      version: "0.1.0",
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # run 'mix help compile.app' to learn about applications
  def application do
    [
      mod: {Genomeur, []},
      # mod: {TCPServer.Application, []}
      extra_applications: [:logger]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:scenic, "~>  0.11.0"},
      {:scenic_driver_local, "~> 0.11.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  # run 'mix help deps' to learn about dependencies
  # defp deps do
  #  [
  #    # {:dep_from_hexpm, "~> 0.3.0"},
  #    # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  # {:sibling_app_in_umbrella, in_umbrella: true} lol not an umbrella anymore
  #  ]
  # end
end
