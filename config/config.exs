# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# all use the same configuration file. If you want different
# same configuration and dependencies, which is why they
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# connecting app's asset module to scenic
config :scenic, :assets, module: Genomeur.Assets

# config the main viewport for the application
config :genomeur, :viewport,
  name: :main_viewport,
  size: {950, 1600},
  theme: :dark,
  default_scene: Genomeur.Component.ChessPosition,
  drivers: [
    [
      module: Scenic.Driver.Local,
      name: :local,
      window: [resizeable: false, title: "scene"],
      on_close: :stop_system
    ]
  ]

# config :genomeur, IO, pipe: MockCLIViewPipe

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#
