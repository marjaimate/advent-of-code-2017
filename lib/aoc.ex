defmodule Aoc do
  def read_file(input), do: read_file(input, :split_by_line)

  def read_file input, :split_by_line do
    with {:ok, data} <- File.read(input) do
      data
      |> String.split("\n")
      |> Enum.reject(&(&1 == ""))
    end
  end

  def read_file input, :split_by_comma do
    with {:ok, data} <- File.read(input) do
      data
      |> String.split(",")
      |> Enum.map(&(String.replace(&1, "\n", "")))
    end
  end
end
