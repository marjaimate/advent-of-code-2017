defmodule Dec16 do
  @file_name "dec16.data"
  @programs "abcdefghijklmnop"

  def solve do
    with instructions <- Aoc.read_file(@file_name, :split_by_comma) do
      @programs
      |> String.codepoints
      |> solve(instructions)
      |> Enum.join
    end
  end

  def solve2 do
    with instructions <- Aoc.read_file(@file_name, :split_by_comma),
         programs <- String.codepoints(@programs)
    do
      cycle = get_cycle(programs, instructions, [])
      ind = rem(1000000000, length(cycle))

      cycle
      |> Enum.at(ind - 1)
      |> Enum.join
    end
  end

  def get_cycle(programs, instructions, acc) do
    next = solve(programs, instructions)
    case Enum.member?(acc, next) do
      false -> get_cycle(next, instructions, acc ++ [next])
      true -> acc
    end
  end

  def solve_times(programs, _instructions, 0), do: programs
  def solve_times programs, instructions, n do
    solve_times(solve(programs, instructions), instructions, n-1)
  end

  def solve programs, instructions do
    instructions
    |> List.foldl(programs, &(dance(&2, &1)))
  end

  def dance list, <<ins::binary-size(1), params :: binary>> do
    dance(list, ins, params)
  end

  # Spin
  def dance list, "s", n do
    n1 = String.to_integer(n)
    {h, t} = Enum.split(list, -n1)
    t ++ h
  end

  # Exchange
  def dance list, "x", n do
    [pos_a, pos_b] = n
             |> String.split("/")
             |> Enum.map(&String.to_integer/1)
             |> Enum.sort
    {head, [a | rest]} = Enum.split(list, pos_a)
    {middle, [b | tail]} = Enum.split(rest, pos_b - pos_a - 1)

    head ++ [b] ++ middle ++ [a] ++ tail
  end

  # Partner
  def dance list, "p", n do
    [prog_a, prog_b] = String.split(n, "/")

    {head, [a | rest]} = Enum.split_while(list, &(&1 != prog_a))
    case Enum.member?(head, prog_b) do
      true ->
        {head1, [b | middle]} = Enum.split_while(head, &(&1 != prog_b))
        head1 ++ [a] ++ middle ++ [b] ++ rest
      false ->
        {middle, [b | tail]} = Enum.split_while(rest, &(&1 != prog_b))
        head ++ [b] ++ middle ++ [a] ++ tail
    end
  end
end
