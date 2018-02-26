# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config
#
## General application configuration
#config :life,
#  ecto_repos: [Life.Repo]

# Configures the endpoint
config :life, LifeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1iuV2w0vb4RBXpWxOyQ9MgaVwRUoRJeRUuBDcd4XMYAeQRAd726mlqL5/9jDIBpP",
  render_errors: [view: LifeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Life.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
