defmodule TransactApp.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add(:description, :string)
      add(:account_id, references(:accounts))

      timestamps()
    end
  end
end
