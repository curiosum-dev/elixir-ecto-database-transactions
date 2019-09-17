# Run the code and inspect results yourself:
require IEx

case TransactApp.Bank.Batches.transfer_money(1, 2, 10000) |> TransactApp.Repo.transaction() do
  {:ok, results} -> IEx.pry()
  {:error, step, reason, results} -> IEx.pry()
end
