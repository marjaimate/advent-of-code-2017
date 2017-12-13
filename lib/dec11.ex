defmodule Dec11 do
  @input "dec11.data"

  def solve do
    @input
    |> Aoc.read_file(:split_by_comma)
    |> solve
    |> distance(starting())
  end

  def solve2 do
    @input
    |> Aoc.read_file(:split_by_comma)
    |> solve2
  end

  def solve2 input do
    List.foldl input, {starting(), 0}, &Dec11.step2/2
  end

  def solve input do
    List.foldl input, starting(), &Dec11.step/2
  end

  def distance %{x: x1, y: y1, z: z1}, %{x: x2, y: y2, z: z2} do
    [x1 - x2, y1 - y2, z1 - z2]
    |> Enum.map(&abs/1)
    |> Enum.max
  end

  def step2 dir, {%{x: x1, y: y1, z: z1}, d} do
    %{x: x2, y: y2, z: z2} = vector(dir)
    new = %{x: x1 + x2, y: y1 + y2, z: z1 + z2}

    {new, Enum.max([distance(starting(), new), d])}
  end

  def step dir, %{x: x1, y: y1, z: z1} do
    %{x: x2, y: y2, z: z2} = vector(dir)
    %{x: x1 + x2, y: y1 + y2, z: z1 + z2}
  end

  def vector("n"),  do: %{x: 0, y: 1, z: -1}
  def vector("ne"), do: %{x: 1, y: 0, z: -1}
  def vector("se"), do: %{x: 1, y: -1, z: 0}
  def vector("s"),  do: %{x: 0, y: -1, z: 1}
  def vector("sw"), do: %{x: -1, y: 0, z: 1}
  def vector("nw"), do: %{x: -1, y: 1, z: 0}

  def starting, do: %{x: 0, y: 0, z: 0}
end
