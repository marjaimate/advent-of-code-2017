defmodule Dec13 do
  @input "dec13.data"

  def get_firewall do
    @input
    |> Aoc.read_file
    |> Enum.map(&Dec13.parse/1)
  end

  def solve do
    get_firewall()
    |> solve
  end

  def solve firewall do
    firewall
    |> check_at(0)
    |> Enum.map(fn {d, r, _} -> d * r end)
    |> Enum.sum
  end

  def check_at firewall, time do
    firewall
    |> Enum.filter(fn {depth, _r, interval} -> rem(time + depth, interval) == 0 end)
  end

  def solve2 do
    get_firewall()
    |> solve2
  end

  def solve2 firewall do
    0..10000000
    |> Enum.reduce([], fn i, acc ->
      case check_at(firewall, i) do
        [] -> acc ++ [i]
        _ -> acc
      end
    end)
  end

  def parse str do
    [depth, range] = String.split(str, ": ") |> Enum.map(&String.to_integer/1)
    # Calculate the interval
    {depth, range, 2 * (range - 1)}
  end
end
