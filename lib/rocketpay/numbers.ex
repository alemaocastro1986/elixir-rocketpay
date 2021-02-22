defmodule Rocketpay.Numbers do
  def sum_from_file(file) do
    file = File.read("#{file}.csv")
    handle_file(file)
  end

  defp handle_file({:ok, file}) do
    result =
      file
      |> String.split(",", trim: true)
      |> Enum.reduce(0, &(&2 + String.to_integer(&1)))

    {:ok, %{data: result}}
  end

  defp handle_file({:error, _reason}), do: {:error, %{message: "Invalid file"}}
end
