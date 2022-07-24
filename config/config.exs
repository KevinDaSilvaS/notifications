# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :notifications, NotificationsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: NotificationsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Notifications.PubSub,
  live_view: [signing_salt: "7RiP+huH"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :notifications, Notifications.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :couchdb, Repository.Notifications,
  host:     System.get_env("COUCHDB_HOST")     || "172.17.0.4",
  user:     System.get_env("COUCHDB_USER")     || "user",
  password: System.get_env("COUCHDB_PASSWORD") || "12345",
  port:     System.get_env("COUCHDB_PORT")

config :broadway, NotificationsConsumer.Consumer,
  rabbit_host: System.get_env("RABBIT_HOST") || "172.17.0.3",
  socket_url: "ws://0.0.0.0:4000/notifications/websocket"

config :channel, NotificationsWeb.NotificationsChannel,
  broadcasting_key: System.get_env("BROADCASTING_KEY") || "admin"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
