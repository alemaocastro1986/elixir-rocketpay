defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true
  use ExUnit.Case

  alias Rocketpay.{Repo, User}
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all parameters are valid, returns a user" do
      params = %{
        name: "Johnny Rocket",
        age: 34,
        email: "johnny.rocket@test.com",
        nickname: "johnny.rocket",
        password: "123456"
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{
               id: ^user_id,
               name: "Johnny Rocket",
               age: 34,
               email: "johnny.rocket@test.com",
               nickname: "johnny.rocket",
               password: _
             } = user
    end

    test "when age is invalid, returns a error" do
      params = %{
        name: "Johnny Rocket",
        age: 17,
        email: "johnny.rocket@test.com",
        nickname: "johnny.rocket",
        password: "123456"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Create.call(params)
      assert %{age: ["must be greater than or equal to 18"]} = errors_on(changeset)
    end

    test "when password is missing, returns a error" do
      params = %{
        name: "Johnny Rocket",
        age: 17,
        email: "johnny.rocket@test.com",
        nickname: "johnny.rocket"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Create.call(params)
      assert %{password: ["can't be blank"]} = errors_on(changeset)
    end

    test "when name, nickname and email is missing, returns a error" do
      params = %{
        age: 17,
        password: "12346"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Create.call(params)

      assert %{name: ["can't be blank"], email: ["can't be blank"], nickname: ["can't be blank"]} =
               errors_on(changeset)
    end
  end
end
