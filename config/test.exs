import Config

# Configure your database
config :transact_app, TransactApp.Repo,
  username: "postgres",
  password: "postgres",
  database: "transact_app_test",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
