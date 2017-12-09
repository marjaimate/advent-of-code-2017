defmodule Dec9 do
  def solve do
    with {:ok, data} <- File.read("dec9.data") do
      {solve(data), solve2(data)}
    end
  end

  def solve input do
    String.codepoints(input)
    |> parse("")
    |> counter({0, 0})
  end

  def solve2 input do
    String.codepoints(input)
    |> garbage_count(0)
  end

  def garbage_count([], acc), do: acc
  def garbage_count(["!", _ | tail], acc), do: garbage_count(tail, acc)
  def garbage_count(["<" | tail], acc) do
    {tail2, count} = skip_to_garbage_end(tail, 0)
    garbage_count(tail2, acc + count)
  end
  def garbage_count([ _ | tail], acc), do: garbage_count(tail, acc)

  def counter("", {current, depth}), do: {current, depth}
  def counter("{" <> tail, {current, depth}) do
     counter(tail, {current, depth + 1})
  end
  def counter("}" <> tail, {current, depth}) do
    counter(tail, {current + depth, depth - 1})
  end

  # Parser
  # < = garb start
  # > = garb end
  # ! = ignore next
  # { =  group start
  # } = group end

  def parse([], acc), do: acc
  def parse(["<" | tail], acc) do
    {tail2, _} = skip_to_garbage_end(tail, 0)
    parse(tail2, acc)
  end
  def parse(["{" | tail], acc), do: parse(tail, acc <> "{")
  def parse(["}" | tail], acc), do: parse(tail, acc <> "}")
  def parse([_ | tail], acc), do: parse(tail, acc)

  # Skip and count
  def skip_to_garbage_end(["!", _ | tail], acc), do: skip_to_garbage_end(tail, acc)
  def skip_to_garbage_end([">" | tail], acc), do: {tail, acc}
  def skip_to_garbage_end([_ | tail], acc), do: skip_to_garbage_end(tail, acc + 1)
end
