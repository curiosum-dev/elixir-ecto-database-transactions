import Ecto.Query
alias Ecto.Multi
alias TransactApp.Bank.Account

transfer_amount = 50

retrieve_accounts = fn repo, _ ->
  case from(acc in Account, where: acc.id in [1, 2]) |> repo.all() do
    [acc_a, acc_b] -> {:ok, {acc_a, acc_b}}
    _ -> {:error, :account_not_found}
  end
end

verify_balances = fn _repo, %{retrieve_accounts_step: {acc_a, acc_b}} ->
  # we don't do anything to account B, but we could
  if acc_a.balance < transfer_amount,
    do: {:error, :balance_too_low},
    else: {:ok, {acc_a, acc_b, transfer_amount}}
end

subtract_from_a = fn repo, %{verify_balances_step: {acc_a, _, verified_amount}} ->
  # repo.update will return {:ok, %Account{...}} or {:error, #Ecto.Changeset<...>} -
  # {:ok, value} or {:error, value} is what these functions are expected to return.
  acc_a
  |> Account.changeset(%{balance: acc_a.balance - verified_amount})
  |> repo.update()
end

add_to_b = fn repo, %{verify_balances_step: {_, acc_b, verified_amount}} ->
  acc_b
  |> Account.changeset(%{balance: acc_b.balance + verified_amount})
  |> repo.update()
end

batch =
  Multi.new()
  |> Multi.run(:retrieve_accounts_step, retrieve_accounts)
  |> Multi.run(:verify_balances_step, verify_balances)
  |> Multi.run(:subtract_from_a_step, subtract_from_a)
  |> Multi.run(:add_to_b_step, add_to_b)

# Inspect the result:
require IEx
IEx.pry()
