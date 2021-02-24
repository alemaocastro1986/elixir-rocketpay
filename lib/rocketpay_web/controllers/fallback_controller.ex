defmodule RocketpayWeb.FallbackControler do
  use RocketpayWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = result}) do
    conn
    |> put_status(422)
    |> put_view(RocketpayWeb.ErrorView)
    |> render("422.json", result: result)
  end

  def call(conn, {:error, result}) do
    conn
    |> put_status(400)
    |> put_view(RocketpayWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
