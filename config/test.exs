import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :notifications, NotificationsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "3jKy8lNrB7EnxWi7WKs8ZBzjhzb53qw+PuS/5Q+X10ADk7hizpuE1ah4j5Wtsp8v",
  server: false

# In test we don't send emails.
config :notifications, Notifications.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
