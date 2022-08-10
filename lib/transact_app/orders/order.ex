defmodule TransactApp.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias TransactApp.Orders.LineItem
  alias TransactApp.Bank.Account

  schema "orders" do
    field :status, Ecto.Enum, values: [:pending, :finalized], default: :pending
    field :total, :decimal, default: 0.0

    embeds_many :line_items, LineItem
    belongs_to :ordering_account, Account
    belongs_to :selling_account, Account

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:ordering_account_id, :selling_account_id])
    |> cast_line_items()
    |> validate_required([:status, :total, :ordering_account_id, :selling_account_id])
  end

  def lock_line_items_changeset(order) do
    order
    |> change(%{line_items: Enum.map(order.line_items, &LineItem.lock_changeset(&1))})
  end

  defp cast_line_items(order_changeset) do
    order_changeset
    |> cast_embed(:line_items)
    |> recalculate_total()
  end

  defp recalculate_total(order_changeset) do
    order_changeset
    |> apply_changes()
    |> Map.get(:line_items)
    |> Stream.map(& &1.price)
    |> Enum.reduce(fn price, acc -> Decimal.add(price, acc) end)
    |> then(&put_change(order_changeset, :total, &1))
  end
end
