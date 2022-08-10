defmodule TransactApp.CheckoutService do
  # Cross-context service, finalizing order and transferring money between
  # parties
  alias Ecto.Multi
  alias TransactApp.Bank.Batches, as: BankBatches
  alias TransactApp.Orders.Batches, as: OrderBatches
  alias TransactApp.Repo

  def run(order) do
    OrderBatches.finalize_order(order)
    |> BankBatches.transfer_money(
      order.ordering_account_id,
      order.selling_account_id,
      order.total
    )
    |> Repo.transaction()
  end
end
