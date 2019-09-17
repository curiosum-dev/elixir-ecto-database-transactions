import Ecto.Query
alias TransactApp.Bank.Account
alias TransactApp.Repo

transfer = 50

result =
  Repo.transaction(fn ->
    [acc_a, acc_b] = from(acc in Account, where: acc.id in [1, 2]) |> Repo.all()

    if acc_a.balance < transfer, do: Repo.rollback(:balance_too_low)

    update1 = acc_a |> Account.changeset(%{balance: acc_a.balance - 50}) |> Repo.update!()
    update2 = acc_b |> Account.changeset(%{balance: acc_b.balance + 50}) |> Repo.update!()

    {update1, update2}
  end)

# Inspect the result:
require IEx
IEx.pry()
