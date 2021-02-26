defmodule RocketpayWeb.WelcomeControllerTest do
  use RocketpayWeb.ConnCase, async: true
  use ExUnit.Case, async: true

  setup %{conn: conn} do
    %{conn: conn}
  end

  describe "index/2" do
    test "when all parameters is valid, return a sum numbers", %{conn: conn} do
      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/numbers")
        |> json_response(:ok)

      assert %{"message" => message} = response
      assert String.starts_with?(message, "Welcome to Rocketpay API, Here is your number")
    end

    test "when filename is invalid, return a error message", %{conn: conn} do
      response =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/invalid-file")
        |> json_response(:bad_request)

      assert %{"message" => "Invalid file"} = response
    end
  end
end
