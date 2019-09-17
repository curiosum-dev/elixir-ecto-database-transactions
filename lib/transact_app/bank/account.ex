defmodule TransactApp.Bank.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field(:balance, :integer)

    has_many(:activities, TransactApp.Bank.Activity)

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end
end
