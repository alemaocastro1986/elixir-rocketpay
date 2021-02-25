defmodule Rocketpay.Accounts.Transaction do
  alias Ecto.Multi

  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse
  alias Rocketpay.Repo

  def call(%{"from" => from_id, "to" => to_id, "value" => value}) do
    Multi.new()
    |> Multi.merge(fn _changes -> withdraw(from_id, value) end)
    |> Multi.merge(fn _changes -> deposit(to_id, value) end)
    |> run_transaction()
  end

  defp params_mapper(id, value), do: %{"id" => id, "value" => value}

  defp deposit(id, value) do
    params_mapper(id, value)
    |> Operation.call(:deposit)
  end

  defp withdraw(id, value) do
    params_mapper(id, value)
    |> Operation.call(:withdraw)
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _failed_operation, reason, _changes_so_far} ->
        {:error, reason}

      {:ok, %{deposit: to_account, withdraw: from_account}} ->
        {:ok, TransactionResponse.build(from_account, to_account)}
    end
  end
end
