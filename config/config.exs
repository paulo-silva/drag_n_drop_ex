# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :drag_n_drop_ex, DragNDropExWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LGbHXOeYZ6UaYOLQ/bIJOLSgPy6SU8LgbhpRGT7JaKzibocdf5QAlauR+1lSPE8e",
  render_errors: [view: DragNDropExWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DragNDropEx.PubSub,
  live_view: [signing_salt: "FETFRRgF"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
