defmodule TransactApp.Bank.Batches do
  # Ecto.Multi batch definitions for the Bank context

  alias Ecto.Multi
  alias TransactApp.Bank.Account
  alias TransactApp.Bank.AccountQueries

  # It's handy to have the first argument default to Multi.new()
  # - this way such a batch definition will be fully composable
  # with others.
  def transfer_money(multi \\ Multi.new(), account_id_1, account_id_2, amount) do
    multi
    |> Multi.all(
      :retrieve_accounts_step,
      AccountQueries.account_by_ids([account_id_1, account_id_2])
    )
    |> run_verify_balances_step(amount)
    |> Multi.update(:subtract_from_acc_1_step, &subtract_from_acc_1_step/1)
    |> Multi.update(:add_to_acc_2_step, &add_to_acc_2_step/1)
  end

  defp run_verify_balances_step(multi, amount) do
    Multi.run(
      multi,
      :verify_balances_step,
      fn _repo, %{retrieve_accounts_step: [acc_1, _]} ->
        if Decimal.compare(acc_1.balance, amount) == :lt,
          do: {:error, :balance_too_low},
          else: {:ok, amount}
      end
    )
  end

  defp subtract_from_acc_1_step(changes) do
    %{
      retrieve_accounts_step: [acc_1, _],
      verify_balances_step: verified_amount
    } = changes

    Account.changeset(acc_1, %{balance: Decimal.sub(acc_1.balance, verified_amount)})
  end

  defp add_to_acc_2_step(%{
         retrieve_accounts_step: [_, acc_2],
         verify_balances_step: verified_amount
       }) do
    Account.changeset(acc_2, %{balance: Decimal.add(acc_2.balance, verified_amount)})
  end
end
