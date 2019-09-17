alias Ecto.Multi
alias TransactApp.Bank
alias TransactApp.Bank.Account
alias TransactApp.Repo

{:ok, account1} = Bank.create_account(%{balance: 100})

activity =
  account1 |> Ecto.build_assoc(:activities, %{description: "Account inspected"}) |> Repo.insert!()

{:ok, account2} = Bank.create_account(%{balance: 200})

batch =
  Multi.new()
  |> Multi.update(:update1_step, Account.changeset(account1, %{balance: 1337}))
  |> Multi.update(:update2_step, Account.changeset(account2, %{balance: 7331}))
  |> Multi.insert(:insert_step, Account.changeset(%Account{}, %{balance: 150}))
  |> Multi.delete_all(:delete_step, Ecto.assoc(account1, :activities))
  |> Multi.update(:update3_step, fn %{insert_step: account} ->
    Account.changeset(account, %{balance: 1234})
  end)

result = batch |> Repo.transaction()

# Inspect the result:
require IEx
IEx.pry()
