# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :commits,
  ecto_repos: [Commits.Repo],
  github_access_token: System.get_env("GITHUB_ACCESS_TOKEN")

# Configures the endpoint
config :commits, CommitsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "O10dtSnQ5YqCnnKZcbKXBrMgVw789uj9NJvm9J/A4Q6ZtM4YnD5lwnoL2D2Pl5qP",
  render_errors: [view: CommitsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Commits.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

