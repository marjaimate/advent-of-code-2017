defmodule Dec7 do
  def test do
    [
    "pbga (66)",
    "xhth (57)",
    "ebii (61)",
    "havc (66)",
    "ktlj (57)",
    "fwft (72) -> ktlj, cntj, xhth",
    "qoyq (66)",
    "padx (45) -> pbga, havc, qoyq",
    "tknk (41) -> ugml, padx, fwft",
    "jptl (61)",
    "ugml (68) -> gyxo, ebii, jptl",
    "gyxo (61)",
    "cntj (57)"
    ]
  end

  @input "dec7.data"

  # Build a binary tree
  # from instructions
  # Our tree will be {node_name, weight, [ ..nodes above ... ]}
  def solve do
    @input
    |> Aoc.read_file
    |> solve
  end

  def solve input do
    input
    |> map_discs
    |> find_root
  end

  def map_discs input do
    input
    |> Enum.map(&Dec7.parse_disc/1)
    |> Map.new
  end

  def find_root map do
    {:found, root} = find_parent(map, pick_orphan(map))
    root
  end

  def find_parent discs, current do
    case Enum.find(discs, fn {{_k, _w}, v} -> Enum.find_index(v, &(&1 == current)) end) do
      nil -> {:found, current}
      {{next, _weight}, _} -> find_parent(discs, next)
    end
  end

  def pick_orphan discs do
    {{k, _weight}, _} = Enum.find discs, fn {_,v} -> v == [] end
    k
  end

  # Turn
  #   dcqdop (500) -> jijjnbw, bwdstyz, lnzzwfi
  # to
  #   %{ {dcqdop, 500} => %{} }
  def parse_disc str do
    [node_info | parents] = String.split(str, " -> ")
    {parse_node(node_info), parse_parents(parents)}
  end

  def parse_node(str) do
    [name, weight_str] = String.split(str, " ")
    weight = Enum.join(String.codepoints(weight_str) -- ["(", ")"], "")
    {name, String.to_integer(weight)}
  end

  def parse_parents([]), do: []
  def parse_parents([str]) do
    str
    |> String.split(", ")
  end

  def solve2 do
    @input
    |> Aoc.read_file
    |> solve2
  end

  def solve2 input do
    inp_balance = input
                    |> map_discs
                    |> map_balance
    offenders = inp_balance
                  |> Enum.reject(fn {{_k, _w, b}, _} -> b == :balanced end)
                  |> Enum.map(fn {{k, _w, b}, _} -> {k, {get_offender(b), get_diff(b)}} end)
                  |> Map.new
    [{_, {n, d}}] = offenders
                 |> Enum.reject(fn {_k, {v, _diff}} -> Map.has_key?(offenders, v) end)


    {{n, w, _}, _} = get_node(inp_balance, n)
    IO.puts "#{inspect {n, w, d}}"
    w - d
  end

  def get_diff list do
    ordered_list = list
                   |> Enum.map(fn {_, v} -> v end)
                   |> Enum.sort
    abs(List.first(ordered_list) - List.last(ordered_list))
  end

  def get_offender list do
    [{_w, [n]}] = list
                    |> List.foldl(%{}, fn {k, v}, a -> Map.update(a, v, [k], &(&1 ++ [k])) end)
                    |> Enum.reject(fn {_k, v} -> length(v) > 1 end)
    n
  end

  def map_balance map do
    map
    |> Enum.map(fn {{k,w}, l} -> {{k, w, balanced(map, k)}, l} end)
  end

  def balanced discs, current do
    {{current, _weight}, parents} = get_node(discs, current)

    p_weights = parents
                |> Enum.map(&({&1, get_weight(discs, &1)}))
    case length(Enum.uniq(Enum.map(p_weights, fn {_k, v} -> v end))) do
      0 -> :balanced
      1 -> :balanced
      _ ->
        IO.puts "C: #{current} P: #{inspect p_weights}"
        p_weights
    end
  end

  # Find sub tree weight
  def get_weight discs, current do
    {{^current, weight}, parents} = get_node(discs, current)
    # IO.puts "[GET W] C: #{current} W: #{weight} P: #{inspect parents}"
    case parents do
      [] -> weight
      list ->
        list
        |> Enum.map(&(get_weight(discs, &1)))
        |> Enum.sum
        |> Kernel.+(weight)
    end
  end

  def get_node discs, n do
    Enum.find(discs, fn {{k, _w}, _p} -> k == n
                        {{k, _w, _b}, _p} -> k == n
                        end )
  end
end
