defmodule RocketpayWeb.UsersControllerTest do
  use RocketpayWeb.ConnCase, async: true
  use ExUnit.Case, async: true

  alias Rocketpay.User

  setup %{conn: conn} do
    %{conn: conn}
  end

  describe "create/2" do
    test "when all parameters is valid, create a new user", %{conn: conn} do
      params = %{
        "name" => "John Doe",
        "email" => "jd@teste.com",
        "nickname" => "j_doe",
        "password" => "123456",
        "age" => "34"
      }

      response =
        conn
        |> post("/api/users", params)
        |> json_response(:created)

      assert %{"message" => "user created", "user" => user} = response
      assert user["name"] == "John Doe"
      assert user["nickname"] == "j_doe"

      assert %{"balance" => "0.00", "id" => _nil} = user["account"]
    end
  end
end
