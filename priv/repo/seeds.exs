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
