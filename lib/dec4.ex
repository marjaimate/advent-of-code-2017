defmodule Dec4 do
  def solve do
    with {:ok, data} = File.read("dec4.data") do
      data
      |> String.split("\n")
      |> Enum.reject(&(&1 == ""))
      |> solve
    end
  end

  def solve list do
    list
    |> Enum.map(&(String.split(&1, " ")))
    |> Enum.map(&Dec4.words_count/1)
    |> Enum.map(&Dec4.valid_pass_word/1)
    |> Enum.sum
  end

  def words_count words do
    List.foldl words, %{}, fn (w, acc) -> Map.update(acc, w, 0, &(&1 + 1)) end
  end

  def valid_pass_word map do
    res = map
    |> Map.values
    |> Enum.reject(fn x -> x == 0 end)
    |> length
    IO.puts "#{res} === #{inspect map}"

    case res do
      0 -> 1
      _ -> 0
    end
  end
end
