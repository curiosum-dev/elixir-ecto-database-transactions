defmodule TransactApp.Bank.AccountQueries do
  import Ecto.Query

  alias TransactApp.Bank.Account

  def account_by_ids(query \\ base(), ids) do
    query
    |> where([account: account], account.id in ^ids)
  end

  defp base, do: from(_ in Account, as: :account)
end
