defmodule Rocketpay.Accounts.Deposit do
  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Repo

  def call(params) do
    Operation.call(params, :deposit)
    |> run_transaction()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _failed_operation, reason, _changes_so_far} -> {:error, reason}
      {:ok, %{deposit: account}} -> {:ok, account}
    end
  end
end
