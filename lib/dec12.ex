defmodule Dec12 do
  @input "dec12.data"

  def solve do
    @input
    |> Aoc.read_file
    |> List.foldl(%{}, &Dec12.parse/2)
    |> solve
  end

  def solve input do
    input
    |> reach("0")
    |> length
  end

  def parse conn, acc do
    [n, list] = String.split(conn, " <-> ")
    Map.put acc, n, String.split(list, ", ")
  end

  def reach connections, target do
    with {neighbours, conn} <- Map.pop(connections, target, []) do
      Enum.reduce(neighbours, [target], &( Enum.uniq(&2 ++ reach(conn, &1)) ))
    end
  end

  def solve2 do
    @input
    |> Aoc.read_file
    |> List.foldl(%{}, &Dec12.parse/2)
    |> solve2
  end

  def solve2 input do
    input
    |> groups
  end

  def groups connections do
    connections
    |> Map.keys()
    |> List.foldl(%{}, &(Map.put(&2, &1, reach(connections, &1))))
    |> Map.values()
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq
  end
end
