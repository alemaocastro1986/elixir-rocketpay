defmodule RocketpayWeb.WelcomeController do
  use RocketpayWeb, :controller

  alias Rocketpay.Numbers

  def index(conn, %{"filename" => filename}) do
    filename
    |> Numbers.sum_from_file()
    |> handle_response(conn)
  end

  defp handle_response({:ok, %{data: number}}, conn) do
    conn
    |> put_status(:ok)
    |> put_resp_header("location", Routes.welcome_path(conn, :index, "numbers"))
    |> json(%{message: "Welcome to Rocketpay API, Here is your number #{number}."})
  end

  defp handle_response({:error, reason}, conn) do
    conn
    |> put_status(:bad_request)
    |> json(%{message: "#{reason}"})
  end
end
