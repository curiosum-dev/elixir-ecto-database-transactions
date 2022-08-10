defmodule TransactApp.Repo.Migrations.ChangeAccountBalanceToDecimal do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      modify(:balance, :decimal)
    end
  end
end
