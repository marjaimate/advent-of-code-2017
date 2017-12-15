defmodule Dec10 do
  # For XOR
  import Bitwise

  @input [130,126,1,11,140,2,255,207,18,254,246,164,29,104,0,224]
  @input2 "130,126,1,11,140,2,255,207,18,254,246,164,29,104,0,224"

  def solve do
    (0..255)
    |> Enum.to_list
    |> solve(@input)
  end

  def solve list, ins do
    {[a1, a2 | _], _, _} = steps(list, ins, 0, 0)
    a1 * a2
  end

  def steps(list, [], current, skip_size), do: {list, current, skip_size}

  def steps list, [1 | rest], current, skip_size do
    nc = next_current(list, current, 1 + skip_size)
    steps(list, rest, nc, skip_size + 1)
  end

  def steps list, [steps | rest], current, skip_size do
    nc = next_current(list, current, steps + skip_size)

    circular_split(list, current, steps)
    |> steps(rest, nc, skip_size + 1)
  end

  def circular_split(list, current, steps) when (current + steps) <= length(list) do
    with {head, rev} <- Enum.split(list, current),
         {rev2, tail} <- Enum.split(rev, steps) do
         head ++ Enum.reverse(rev2) ++ tail
    end
  end

  def circular_split(list, current, steps)  do
    with {head, rev1} <- Enum.split(list, current),
        {rev2, middle} <- Enum.split(head, steps - length(rev1)) do
          # Reverse and split again
        {t, h} = Enum.reverse(rev1 ++ rev2) |> Enum.split(length(rev1))
        h ++ middle ++ t
    end
  end

  def next_current(list, current, steps) do
    rem(current + steps, length(list))
  end

  def solve2 do
    knot_hash @input2
  end

  def knot_hash list, ins do
    # sparse_hash -> dense hash
    with {result, _, _} <- Enum.reduce(1..64, {list, 0, 0}, fn _, {l, c, s} -> steps(l, ins, c, s) end) do
      result
      |> Enum.chunk_every(16)
      |> Enum.map(fn chunk -> Enum.reduce(chunk, 0, &(&1 ^^^ &2)) end)
      |> Enum.map(&to_padded_hex/1)
      |> Enum.join()
    end
  end

  def to_padded_hex(number) do
    number |> Integer.to_string(16) |> String.pad_leading(2, "0") |> String.downcase()
  end

  def knot_hash str do
    ins = str
          |> to_charlist()
          |> Enum.concat([17, 31, 73, 47, 23])

    (0..255)
    |> Enum.to_list
    |> knot_hash(ins)
  end
end
