defmodule TransactApp.Repo do
  use Ecto.Repo,
    otp_app: :transact_app,
    adapter: Ecto.Adapters.Postgres
end
