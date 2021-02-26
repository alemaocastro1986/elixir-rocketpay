defmodule RocketpayWeb.AccountsControllerTest do
  use ExUnit.Case, async: true
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  setup %{conn: conn} do
    user_1 = %{
      name: "Johnny Rocket",
      age: 34,
      email: "johnny.rocket@test.com",
      nickname: "johnny.rocket",
      password: "123456"
    }

    user_2 = %{
      name: "Jane Rocket",
      age: 34,
      email: "jane.rocket@test.com",
      nickname: "jane.rocket",
      password: "123456"
    }

    {:ok, %User{account: %Account{id: account1_id}}} = Rocketpay.create_user(user_1)
    {:ok, %User{account: %Account{id: account2_id}}} = Rocketpay.create_user(user_2)

    conn =
      conn
      |> put_req_header("authorization", "Basic cm9ja2V0c2VhdDpuZXZlcnN0b3BsZWFybmluZw==")

    %{conn: conn, account1_id: account1_id, account2_id: account2_id}
  end

  describe "deposit/2" do
    test "when all parameters are valid, make the deposit", %{
      conn: conn,
      account1_id: account1_id
    } do
      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account1_id, %{value: "100.0"}))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "100.00", "id" => _id},
               "message" => "Balance changed successfully."
             } = response
    end

    test "when value is invalid, return error message", %{conn: conn, account1_id: account1_id} do
      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account1_id, %{value: "banana"}))
        |> json_response(:bad_request)

      assert %{
               "message" => "Invalid deposit, value"
             } = response
    end
  end

  describe "withdraw/2" do
    test "when all parameters are valid, make the withdraw", %{
      conn: conn,
      account1_id: account1_id
    } do
      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account1_id, %{value: "100.0"}))
        |> post(Routes.accounts_path(conn, :withdraw, account1_id, %{value: "50.0"}))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "50.00", "id" => _id},
               "message" => "Balance changed successfully."
             } = response
    end

    test "when insufficient balance, returns error message", %{
      conn: conn,
      account1_id: account1_id
    } do
      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account1_id, %{value: "50.0"}))
        |> json_response(422)

      assert %{
               "message" => %{"balance" => ["is invalid"]}
             } = response
    end
  end

  describe "transaction/2" do
    test "when all parameters are valid, make the withdraw", %{
      conn: conn,
      account1_id: account1_id,
      account2_id: account2_id
    } do
      body = %{
        from: account1_id,
        to: account2_id,
        value: "30.0"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account1_id, %{value: "100.0"}))
        |> post(Routes.accounts_path(conn, :transaction, body))
        |> json_response(:ok)

      assert %{
               "message" => "Transaction done successfully.",
               "transaction" => %{
                 "from_account" => %{
                   "balance" => "70.00",
                   "id" => _from_account_id
                 },
                 "to_account" => %{
                   "balance" => "30.00",
                   "id" => _to_account_id
                 }
               }
             } = response
    end

    test "when insufficient balance in from, returns error message", %{
      conn: conn,
      account1_id: account1_id,
      account2_id: account2_id
    } do
      body = %{
        from: account1_id,
        to: account2_id,
        value: "150.0"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account1_id, %{value: "100.0"}))
        |> post(Routes.accounts_path(conn, :transaction, body))
        |> json_response(422)

      assert %{"message" => %{"balance" => ["is invalid"]}} = response
    end
  end
end
