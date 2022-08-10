defmodule TransactApp.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:status, :string, null: false, default: "pending")
      add(:line_items, {:array, :map}, default: [])
      add(:total, :decimal, null: false, default: 0.0)

      add(:ordering_account_id, references(:accounts), null: false)
      add(:selling_account_id, references(:accounts))

      timestamps()
    end

    create index(:orders, :status)
    create index(:orders, :ordering_account_id)
    create index(:orders, :selling_account_id)
  end
end
