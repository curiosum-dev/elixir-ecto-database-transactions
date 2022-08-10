defmodule TransactApp.Bank.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :description, :string

    belongs_to :account, TransactApp.Bank.Account

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
