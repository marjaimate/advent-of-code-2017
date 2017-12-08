defmodule Dec8 do
  def solve do
    with {:ok, data} = File.read("dec8.data") do
      data
      |> String.split("\n")
      |> Enum.reject(&(&1 == ""))
      |> solve
    end
  end

  def solve input do
    {m, highest} = input
        |> List.foldl({%{}, 0}, &Dec8.parse_instruction/2)
    IO.puts "M #{inspect m}"

    s1 = m
         |> Map.values
         |> Enum.sort
         |> List.last
    {s1, highest}
  end

  def parse_instruction ins, {acc, high} do
   [reg, op, op_v, "if", chk_reg, chk_op, chk_v] = String.split(ins)

   case check_valid?(acc[chk_reg], chk_op, String.to_integer(chk_v)) do
     :yes ->
        acc2 = Map.put(acc, reg, update_value(acc[reg], op, String.to_integer(op_v)))

        {acc2, highest(acc2, high)}
     :no -> {acc, high}
   end
  end

  def highest(m, high) do
    cand = m
           |> Map.values
           |> Enum.sort
           |> List.last
    highest?(cand, high)
  end

  def highest?(c, h) when c > h, do: c
  def highest?(_, h), do: h

  def update_value(nil, op, op_v), do: update_value(0, op, op_v)
  def update_value(current, "inc", op_v), do: current + op_v
  def update_value(current, "dec", op_v), do: current - op_v

  def check_valid?(nil, op, v), do: check_valid?(0, op, v)
  def check_valid?(v, "==", w) when v == w, do: :yes
  def check_valid?(v, "!=", w) when v != w, do: :yes
  def check_valid?(v, ">=", w) when v >= w, do: :yes
  def check_valid?(v, ">", w) when v > w, do: :yes
  def check_valid?(v, "<=", w) when v <= w, do: :yes
  def check_valid?(v, "<", w) when v < w, do: :yes
  def check_valid?(_v, _op, _w), do: :no
end
