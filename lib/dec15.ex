defmodule Dec15 do
  @gen_a 873
  @gen_b 583
  @factor_a 16807
  @factor_b 48271
  @rem_factor 2147483647
  @rem_check_a 4
  @rem_check_b 8

  def solve, do: solve(@gen_a, @gen_b)

  def solve(a, b) do
    1..40000000
    |> Enum.reduce({a, b, 0}, fn(_, {a1, b1, m}) ->
      a2 = produce(a1, @factor_a, @rem_factor)
      b2 = produce(b1, @factor_b, @rem_factor)
      case compare(a2, b2) do
        :match -> {a2, b2, m + 1}
        :nomatch -> {a2, b2, m}
      end
    end)
  end

  def solve2, do: solve2(@gen_a, @gen_b)

  def solve2(a, b) do
    # Product list, filtered
    a_list = [a] ++ Enum.to_list(1..40000000)
             |> Stream.scan(fn _, a1 -> produce(a1, @factor_a, @rem_factor) end)
             |> Stream.reject(&( rem(&1, @rem_check_a) > 0 ))
             |> Enum.to_list
             |> Enum.slice(0, 5000000)
    b_list = [b] ++ Enum.to_list(1..40000000)
             |> Stream.scan(fn _, b1 -> produce(b1, @factor_b, @rem_factor) end)
             |> Stream.reject(&( rem(&1, @rem_check_b) > 0 ))
             |> Enum.to_list
             |> Enum.slice(0, 5000000)

    # and zip the 2 lists together
    Stream.zip(a_list, b_list)
    |> Stream.map(fn({aa, bb}) ->
      case compare(aa, bb) do
        :match ->  1
        :nomatch ->  0
      end
    end)
    |> Enum.sum
  end

  def produce_filter(list, num, rem_check) do
    case rem(num, rem_check) do
      0 -> list ++ [num]
      _ -> list
    end
  end

  def produce(current, factor, rem_factor) do
    rem(current * factor, rem_factor)
  end

  def compare(a, b) do
    compare_bits(get_bits(a), get_bits(b))
  end

  def get_bits(a) do
    Enum.map(0..16, &(&1 * 0)) ++ Integer.digits(a, 2)
    |> Enum.slice(-16..-1)
  end

  def compare_bits(a, a), do: :match
  def compare_bits(_, _), do: :nomatch
end
