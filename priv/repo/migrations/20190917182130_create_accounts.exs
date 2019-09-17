defmodule TransactApp.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add(:balance, :integer)

      timestamps()
    end

    create(
      constraint("accounts", "balance_must_not_be_negative",
        check: "balance >= 0",
        comment: "Account balance cannot be below zero"
      )
    )
  end
end
