defmodule Dec4 do
  @input "dec4.data"

  def solve do
    @input
    |> Aoc.read_file
    |> solve
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

  def solve2 do
    @input
    |> Aoc.read_file
    |> solve2
  end

  def solve2 list do
    list
    |> Enum.map(&(String.split(&1, " ")))
    |> Enum.map(&Dec4.anagrams_count/1)
    |> Enum.map(&Dec4.valid_pass_word/1)
    |> Enum.sum
  end

  def anagrams_count words do
    words
      |> Enum.map(&Dec4.normalize/1)
      |> List.foldl(%{}, fn (w, acc) -> Map.update(acc, w, 0, &(&1 + 1)) end)
  end

  ## Turn words into ordered list of characters
  def normalize word do
    word
    |> String.codepoints
    |> Enum.sort
    |> List.foldl("", &(&2 <> &1))
  end
end
