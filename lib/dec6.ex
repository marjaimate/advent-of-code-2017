defmodule Dec6 do
  @input [4, 10, 4, 1, 8, 4, 9, 14, 5, 1, 14, 15, 0, 15, 3, 5]

  def solve do
    @input
    |> solve()
  end

  def solve input do
    input
    |> get_states
    |> length
  end

  def get_states(input) do
    input
    |> Enum.with_index
    |> Enum.map(fn {k,v}->{v,k} end)
    |> Map.new
    |> get_states([])
  end

  def get_states(blocks, states) do
    # Find the max element
    with n = Enum.max(Map.values(blocks)) do
      # Make sure we pick the lowest index
      {i, n} = Enum.find blocks, fn {_, x} -> x == n end
      new_blocks = redistribute(Map.put(blocks, i, 0), i + 1, n)

      # IO.puts "Blocks #{inspect blocks} I: #{i}, N: #{n} new => #{inspect new_blocks}"
      case check_blocks(states, new_blocks) do
        nil -> get_states(new_blocks, states ++ [new_blocks])
        _   -> states ++ [new_blocks]
      end
    end
  end

  def check_blocks(states, blocks) do
    Enum.find(states, &(&1 == blocks))
  end

  # To do this, it removes all of the blocks from the selected bank,
  # then moves to the next (by index) memory bank and inserts one of the blocks.
  def redistribute(blocks, _i, 0), do: blocks
  def redistribute(blocks, i, n) do
    # IO.puts "[RED] #{inspect blocks}, #{i}, #{n}"
    case Map.has_key?(blocks, i) do
      true  -> redistribute(Map.put(blocks, i, blocks[i] + 1), i + 1, n - 1)
      false -> redistribute(blocks, 0, n)
    end
  end

  def solve2 do
    @input
    |> solve2
  end

  def solve2 input do
    states = get_states(input)
    target = List.last(states)
    {target, i} = states
                  |> Enum.with_index(1)
                  |> Enum.find(fn {x, _} -> x == target end)
    length(states) - i
  end
end
