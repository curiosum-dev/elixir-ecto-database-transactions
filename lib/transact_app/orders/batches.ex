defmodule TransactApp.Orders.Batches do
  # Ecto.Multi batch definitions for the Orders context

  alias Ecto.Multi
  alias TransactApp.Orders

  def finalize_order(multi \\ Multi.new(), order) do
    # Notice that, in this function, each step does not depend
    # on any results of previous ones, so we don't need to pass functions
    # as the last arguments of update/3.
    multi
    |> Multi.update(
      :finalize_order,
      Orders.set_order_status_changeset(order, :finalized)
    )
    |> Multi.update(
      :set_order_line_items_locked,
      Orders.lock_order_line_items_changeset(order)
    )
  end
end
