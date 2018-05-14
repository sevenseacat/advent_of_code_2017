defmodule Advent.Day3.Coordinate do
  defstruct x: 0, y: 0, value: 1
end

defmodule Advent.Day3.Progress do
  alias Advent.Day3.Coordinate

  # The ugly that stores the progress of the current position around the board.

  # To build the pattern:
  #   17  16  15  14  13
  #   18   5   4   3  12
  #   19   6   1   2  11
  #   20   7   8   9  10
  #   21  22  23---> ...
  # The sequence of moves is like:
  # run 1: 1 move right
  # run 2: 1 move up
  # run 3: 2 moves left
  # run 4: 2 moves down
  # run 5: 3 moves right
  # run 6: 3 moves up ... see where this is going?
  # So a progress state is { run number, direction, # of moves in run, current move # in run }
  def new do
    {1, {1, 0}, 1, 0}
  end

  def increment(progress, coordinates, fun) do
    new_progress = make_move(progress)
    {x, y} = move(new_progress, coordinates)
    {new_progress, %Coordinate{x: x, y: y, value: fun.({x, y}, coordinates)}}
  end

  defp make_move({run_no, direction, move_count, move_no}) do
    case move_count == move_no do
      true ->
        new_move_count =
          case rem(run_no, 2) do
            0 -> move_count + 1
            1 -> move_count
          end

        {run_no + 1, rotate(direction), new_move_count, 1}

      false ->
        {run_no, direction, move_count, move_no + 1}
    end
  end

  defp move({_, {x1, y1}, _, _}, []), do: {x1, y1}
  defp move({_, {x1, y1}, _, _}, [%Coordinate{x: x2, y: y2} | _]), do: {x1 + x2, y1 + y2}

  defp rotate({1, 0}), do: {0, 1}
  defp rotate({0, 1}), do: {-1, 0}
  defp rotate({-1, 0}), do: {0, -1}
  defp rotate({0, -1}), do: {1, 0}
end

defmodule Advent.Day3.Board do
  alias Advent.Day3.{Coordinate, Progress}

  def build(input, fun),
    do: do_build(Enum.into(1..input, []), [%Coordinate{}], Progress.new(), fun)

  defp do_build([_num], coordinates, _, _), do: coordinates

  defp do_build([num | nums], coordinates, progress, fun) do
    {new_progress, new_coordinate} = Progress.increment(progress, coordinates, fun.(num))
    do_build(nums, [new_coordinate | coordinates], new_progress, fun)
  end
end

defmodule Advent.Day3 do
  alias Advent.Day3.{Board, Coordinate}

  @doc """
  iex> Day3.part1(1)
  0

  iex> Day3.part1(12)
  3

  iex> Day3.part1(23)
  2

  iex> Day3.part1(1024)
  31
  """
  def part1(input) when is_integer(input) do
    input
    |> Board.build(fn num -> fn _, _ -> num + 1 end end)
    |> calculate_distance
  end

  @doc """
  This contains a total hack, with exceptions as control flow.
  The reason for this is that the input figure will try to calculate a board of that size, and
  larger boards are exponentially larger to generate (due to the formula for calculating the
  coordinate value).
  We don't want a board of that size - we want to generate board data until the value exceeds the
  input - and I don't know of any other way to break generation early. So here we go.

  iex> Day3.part2(10)
  %Coordinate{x: -1, y: -1, value: 11}

  iex> Day3.part2(50)
  %Coordinate{x: 2, y: 0, value: 54}

  iex> Day3.part2(100)
  %Coordinate{x: 1, y: 2, value: 122}

  iex> Day3.part2(200)
  %Coordinate{x: -2, y: 1, value: 304}
  """
  def part2(input) when is_integer(input) do
    try do
      input
      |> Board.build(fn _ ->
        fn {x, y} = position, coords ->
          val = calculate_coordinate_value(position, coords)

          case val > input do
            false -> val
            true -> raise RuntimeError, message: %Coordinate{x: x, y: y, value: val}
          end
        end
      end)
    rescue
      e in RuntimeError -> e.message
    end
  end

  @doc """
  Given an {x,y} coordinate, determine the value for it based on all the calculated coordinates so far.
  iex> Day3.calculate_coordinate_value({-1, 0}, [
  ...>  %Coordinate{x: 0, y: 0, value: 1}, %Coordinate{x: 1, y: 0, value: 1}, %Coordinate{x: 1, y: 1, value: 2},
  ...>  %Coordinate{x: 0, y: 1, value: 4}, %Coordinate{x: -1, y: 1, value: 5}])
  10

  iex> Day3.calculate_coordinate_value({0, -1}, [
  ...>  %Coordinate{x: 0, y: 0, value: 1}, %Coordinate{x: 1, y: 0, value: 1}, %Coordinate{x: 1, y: 1, value: 2},
  ...>  %Coordinate{x: 0, y: 1, value: 4}, %Coordinate{x: -1, y: 1, value: 5}, %Coordinate{x: -1, y: 0, value: 10},
  ...>  %Coordinate{x: -1, y: -1, value: 11}])
  23
  """
  def calculate_coordinate_value({x, y}, coords) do
    # Each coordinate has eight possible values which must be summed up... but there will be a maximum of 4.
    coords
    |> find_coordinates([
      {x + 1, y},
      {x + 1, y + 1},
      {x, y + 1},
      {x - 1, y + 1},
      {x - 1, y},
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1}
    ])
    |> Enum.map(& &1.value)
    |> Enum.sum()
  end

  defp calculate_distance([%Coordinate{x: x, y: y} | _]), do: abs(x) + abs(y)

  defp find_coordinates(all_coords, to_find) do
    all_coords
    |> Stream.filter(fn coordinate -> Enum.member?(to_find, {coordinate.x, coordinate.y}) end)
    |> Enum.take(4)
  end
end
