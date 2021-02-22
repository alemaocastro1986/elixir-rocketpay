defmodule Rocketpay.NumbersTest do
  use ExUnit.Case
  alias Rocketpay.Numbers

  describe "sum_from_file/1" do
    test "when there is a file with the given name, return a sum of numbers" do
      assert {:ok, %{data: data}} = Numbers.sum_from_file("numbers")
      assert is_number(data)
      assert is_integer(data)
      assert data == 27
    end

    test "when there is a no file with the given name, return an error" do
      assert {:error, %{message: "Invalid file"}} = Numbers.sum_from_file("not-found")
    end
  end
end
