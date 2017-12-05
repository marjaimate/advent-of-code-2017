defmodule Dec5 do
  def solve do
    {:ok, data} = File.read("dec5.data")
    # Get a map, where key is the index (starts with 1 !)
    # and the value is the instruction
     data
     |> String.split("\n")
     |> Enum.reject(&(&1 == ""))
     |> Enum.map(&String.to_integer/1)
     |> solve
  end

  def solve instructions do
    instructions
    |> Enum.with_index(1)
    |> Enum.map(fn {k,v}->{v,k} end)
    |> Map.new
    |> solve(1, 0)
  end

  def solve instructions, index, n do
    # IO.puts "At index#{index}, step #{n}, #{inspect instructions}"
    case instructions[index] do
      nil -> n
      i ->
        instructions
        |> Map.put(index, i + 1)
        |> solve(index + i, n + 1)
    end
  end

  # If the offset (i) is greater than 3, decrease by 1
  def solve2 do
    {:ok, data} = File.read("dec5.data")
    # Get a map, where key is the index (starts with 1 !)
    # and the value is the instruction
     data
     |> String.split("\n")
     |> Enum.reject(&(&1 == ""))
     |> Enum.map(&String.to_integer/1)
     |> solve2
  end

  def solve2 instructions do
    instructions
    |> Enum.with_index(1)
    |> Enum.map(fn {k,v}->{v,k} end)
    |> Map.new
    |> solve2(1, 0)
  end

  def solve2 instructions, index, n do
    # IO.puts "At index#{index}, step #{n}, #{inspect instructions}"
    case instructions[index] do
      nil -> n
      i ->
        instructions
        |> Map.put(index, value_update(i))
        |> solve2(index + i, n + 1)
    end
  end

  def value_update(i) when i >= 3, do: i - 1
  def value_update(i), do: i + 1
end
