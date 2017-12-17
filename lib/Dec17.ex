defmodule Dec17 do
  @steps 337

  def solve do
    with {result, current} <- step_and_insert([0], 0, @steps, 0, 2017) do
      {_h, [solution | _t]} = Enum.split(result, current + 1)
      solution
    end
  end

  # Keep in mind only inserts at position 1
  # Don't care about the rest, only keep track of the list length, and where we are
  def solve2 do
    fake_step_and_insert(1, 1, @steps, 2, 50000000)
  end

  def fake_step_and_insert(acc, _current, _steps, n, n), do: acc
  def fake_step_and_insert(acc, current, steps, n, finish) when n > (current + steps) do
    fake_step_and_insert(acc, steps + current + 1, steps, n + 1, finish)
  end

  def fake_step_and_insert(acc, current, steps, n, finish) when n <= (current + steps) do
    next_curr = rem(current + steps, n) + 1
    new_acc = case next_curr do
      1 -> n
      _ -> acc
    end
    fake_step_and_insert(new_acc, next_curr, steps, n + 1, finish)
  end

  def step_and_insert(list, current, _steps, n, n), do: {list, current} # End of iteration
  def step_and_insert(list, current, steps, n, finish) when length(list) > (current + steps) do
    # Step forwards 'steps' times
    split_index = steps + current + 1
    list1 = insert_new_at(list, split_index, n + 1)
    # new value's index becomes the current
    step_and_insert(list1, split_index, steps, n + 1, finish)
  end

  # We go around
  def step_and_insert(list, current, steps, n, finish) when length(list) <= (current + steps) do
    split_index = rem(current + steps, length(list)) + 1
    list1 = insert_new_at(list, split_index, n + 1)
    # new value's index becomes the current
    step_and_insert(list1, split_index, steps, n + 1, finish)
  end

  # insert new after current pos
  def insert_new_at(list, index, value) do
    {h, t} = Enum.split(list, index)
    h ++ [value] ++ t
  end
end
