defmodule Dec14 do
  @input "hxtvlmkl"

  def solve, do: solve(@input)

  def solve input do
    input
    |> build_disc()
    |> Enum.map(&Enum.sum/1)
    |> Enum.sum()
  end

  def solve2, do: solve2(@input)

  def solve2 input do
    input
    |> build_grid()
    |> grouper()
    |> length
  end

  def grouper(points), do: grouper(points, [])

  def grouper([], acc), do: acc
  def grouper([point | rest], acc) do
    {group, reduced_list} = get_connected(point, rest)
    grouper(reduced_list, acc ++ [group])
  end

  def get_connected %{x: x1, y: y1} = point, points do
    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.map(fn {x2, y2} -> %{x: x1 + x2, y: y1 + y2} end)
    |> Enum.filter(&Enum.member?(points, &1)) # This gets the neighbours, if any present
    |> List.foldl({[point], points}, fn n, {lp, search_list} ->
       {new_group_points, new_search_list} = get_connected(n, search_list --[n])
       {lp ++ new_group_points, new_search_list}
    end)
  end

  def build_grid input do
    input
    |> build_disc()
    |> Enum.with_index()
    |> Enum.map(&Dec14.map_row/1)
    |> List.flatten
  end

  def map_row {row, y} do
    row
    |> Enum.with_index()
    |> Enum.reject(&match?({0, _col}, &1))
    |> Enum.map(fn {_value, x} -> %{y: y, x: x} end)
  end

  def build_disc input do
    0..127
    |> Enum.map(&("#{input}-#{&1}"))
    |> Enum.map(&Dec14.knot_hash/1)
    |> Enum.map(&Dec14.to_bin/1)
  end

  # Using the solution from the 10th
  def knot_hash(str), do: Dec10.knot_hash(str)

  def to_bin str do
    str
    |> String.codepoints
    |> Enum.chunk_every(2)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.upcase/1)
    |> Enum.map(&Base.decode16!/1)
    |> Enum.map(&(for << digit::1 <- &1 >>, do: digit))
    |> List.flatten
  end
end
