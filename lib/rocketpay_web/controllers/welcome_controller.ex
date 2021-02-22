defmodule RocketpayWeb.WelcomeController do
  use RocketpayWeb, :controller

  alias Rocketpay.Numbers

  def index(conn, %{"filename" => filename}) do
    filename
    |> Numbers.sum_from_file()
    |> handle_response(conn)
  end

  defp handle_response({:ok, result}, conn) do
    conn
    |> put_status(200)
    |> json(%{message: "Welcome to Rocketpay API, Here is your number #{result}."})
  end

  defp handle_response({:error, reason}, conn) do
    conn
    |> put_status(400)
    |> json(%{message: "#{reason}"})
  end
end
