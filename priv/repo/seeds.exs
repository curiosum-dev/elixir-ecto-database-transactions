# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TransactApp.Repo.insert!(%TransactApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TransactApp.Bank
alias TransactApp.Orders
alias TransactApp.Repo

[100, 200, 300, 400]
|> Enum.each(fn balance ->
  {:ok, account} = Bank.create_account(%{balance: balance})

  1..10
  |> Enum.each(fn _ ->
    account
    |> Ecto.build_assoc(:activities, %{description: "Account interaction"})
    |> Repo.insert!()
  end)
end)

accounts = Repo.all(Bank.Account)

accounts
|> then(&for x <- &1, y <- &1, do: {x, y})
|> Enum.reject(fn {a, b} -> a == b end)
|> Enum.each(fn {acc1, acc2} ->
  Orders.create_order(%{
    ordering_account_id: acc1.id,
    selling_account_id: acc2.id,
    line_items: [
      %{name: "Test order #{acc1.id} - #{acc2.id}", price: 10.50}
    ]
  })
end)
