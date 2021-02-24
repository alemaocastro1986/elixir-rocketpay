defmodule Rocketpay.Users.Create do
  alias Ecto.Multi
  alias Rocketpay.{Account, Repo, User}

  def call(params) do
    Multi.new()
    |> Multi.insert(:create_user, User.changeset(params))
    |> Multi.run(:create_account, fn repo, %{create_user: user} ->
      insert_account(user, repo)
    end)
    |> Multi.run(:preload_data, fn repo, %{create_user: user} ->
      preload_data(repo, user)
    end)
    |> run_trasaction()
  end

  defp insert_account(user, repo) do
    user.id
    |> account_chageset()
    |> repo.insert()
  end

  defp account_chageset(user_id), do: Account.changeset(%{user_id: user_id, balance: "0.00"})

  defp preload_data(repo, %User{} = user) do
    {:ok, repo.preload(user, :account)}
  end

  defp run_trasaction(multi) do
    case Repo.transaction(multi) do
      {:error, _failed_operation, reason, _changes_so_far} -> {:error, reason}
      {:ok, %{preload_data: user}} -> {:ok, user}
    end
  end
end
