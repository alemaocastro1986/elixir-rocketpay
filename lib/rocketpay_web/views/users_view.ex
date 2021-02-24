defmodule RocketpayWeb.UsersView do
  use RocketpayWeb, :view
  alias Rocketpay.User

  def render("create.json", %{user: %User{id: id, name: name, nickname: nickname}}) do
    %{
      message: "user created",
      user: %{
        id: id,
        name: name,
        nickname: nickname
      }
    }
  end
end
