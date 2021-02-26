defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.UsersView

  test "renders create.json" do
    params = %{
      name: "Johnny Rocket",
      age: 34,
      email: "johnny.rocket@test.com",
      nickname: "johnny.rocket",
      password: "123456"
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      Rocketpay.create_user(params)

    response = render(UsersView, "create.json", user: user)

    assert %{
             message: "user created",
             user: %{
               account: %{balance: Decimal.new("0.00"), id: account_id},
               id: user_id,
               name: "Johnny Rocket",
               nickname: "johnny.rocket"
             }
           } == response
  end
end
