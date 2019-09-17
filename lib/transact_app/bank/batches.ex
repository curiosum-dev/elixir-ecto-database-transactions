defmodule TransactApp.Bank.Batches do
  alias Ecto.Multi
  alias TransactApp.Bank.Account
  import Ecto.Query, only: [from: 2]

  def transfer_money(acc1_id, acc2_id, amount) do
    Multi.new()
    |> Multi.run(:retrieve_accounts_step, retrieve_accounts(acc1_id, acc2_id))
    |> Multi.run(:verify_balances_step, verify_balances(amount))
    |> Multi.run(:subtract_from_a_step, &subtract_from_a/2)
    |> Multi.run(:add_to_b_step, &add_to_b/2)
  end

  defp retrieve_accounts(acc1_id, acc2_id) do
    fn repo, _ ->
      case from(acc in Account, where: acc.id in [^acc1_id, ^acc2_id]) |> repo.all() do
        [acc_a, acc_b] -> {:ok, {acc_a, acc_b}}
        _ -> {:error, :account_not_found}
      end
    end
  end

  defp verify_balances(transfer_amount) do
    fn _repo, %{retrieve_accounts_step: {acc_a, acc_b}} ->
      if acc_a.balance < transfer_amount,
        do: {:error, :balance_too_low},
        else: {:ok, {acc_a, acc_b, transfer_amount}}
    end
  end

  defp subtract_from_a(repo, %{verify_balances_step: {acc_a, _, verified_amount}}) do
    acc_a
    |> Account.changeset(%{balance: acc_a.balance - verified_amount})
    |> repo.update()
  end

  defp add_to_b(repo, %{verify_balances_step: {_, acc_b, verified_amount}}) do
    acc_b
    |> Account.changeset(%{balance: acc_b.balance + verified_amount})
    |> repo.update()
  end
end
