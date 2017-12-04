defmodule Dec3 do
  @input 312051

  def solve do
    {x, y} = get_coords(@input) # we start from {x,y} coords, with the bottom right corner
    IO.puts "X: #{x} Y: #{y}"
    abs(x) + abs(y)
  end

  def get_coords(target_value) do
    square_size = get_square_size(target_value)
    base_coords = {round( (square_size - 1) / 2), round(- (square_size - 1) / 2)}

    IO.puts "square size #{square_size}"
    IO.puts "starting coords #{inspect base_coords}"
    centre_coords = {0, 0}
    target_coords = get_coords(target_value, square_size, base_coords) # we start from {x,y} coords, with the bottom right corner
  end

  def get_coords(target_value, square_size, start_coords) do
    corner_value = round(:math.pow(square_size, 2))
    IO.puts "Corner Value #{corner_value}"
    diff = corner_value - target_value
    IO.puts "diff #{diff}"
    walking_around([:left, :up, :right, :down], diff, square_size - 1, start_coords)
  end

  # How many rounds do we need to go back?
  # 1 -> only going left
  # 2 -> going up
  # 3 -> going right
  # 4 -> going down
  def walking_around([dir | _rest], diff, square_size, coords) when diff < square_size do
    IO.puts "Finishing up walking #{dir} with #{diff} steps from #{inspect coords}"
    walking_around(dir, diff, coords)
  end

  def walking_around([dir | rest], diff, square_size, coords) do
    IO.puts "Finishing up walking #{dir} with #{diff} steps from #{inspect coords}"
    new_coords = walking_around(dir, square_size, coords)
    walking_around(rest, diff - square_size, square_size, new_coords)
  end

  def walking_around(:left, steps, {x, y}),  do: {x - steps, y}
  def walking_around(:up, steps, {x, y}),    do: {x, y + steps}
  def walking_around(:right, steps, {x, y}), do: {x + steps, y}
  def walking_around(:down, steps, {x, y}),  do: {x, y - steps}

  def get_square_size(input) do
    cand = round(:math.ceil(:math.sqrt(input)))
    case Integer.mod(cand, 2) do
      1 -> cand
      _ -> cand + 1
    end
  end

  ## Second part
  def solve2 do
  end
end
