defmodule Advent.Day3.Coordinate do
  defstruct x: 0, y: 0, value: 0
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
    {1, {1,0}, 1, 1}
  end

  def increment(progress, coordinates, num) do
    new_progress = make_move(progress)
    {x, y} = move(progress, coordinates)
    { new_progress, %Coordinate{x: x, y: y, value: num} }
  end

  defp make_move({run_no, direction, move_count, move_no}) do
    case move_count == move_no do
      true  -> { run_no+1, rotate(direction), div(run_no, move_count), 1 }
      false -> { run_no,   direction,         move_count,              move_no+1 }
    end
  end

  defp move({_, {x1, y1}, _, _}, []), do: {x1, y1}
  defp move({_, {x1, y1}, _, _}, [%Coordinate{x: x2, y: y2} | _]), do: {x1 + x2, y1 + y2}

  defp rotate({1,0}), do: {0,1}
  defp rotate({0,1}), do: {-1,0}
  defp rotate({-1,0}), do: {0,-1}
  defp rotate({0,-1}), do: {1,0}
end

defmodule Advent.Day3.Board do
  alias Advent.Day3.Progress

  def build(input), do: do_build(Enum.into(1..input, []), [], Progress.new)

  defp do_build([_num], coordinates, _), do: coordinates
  defp do_build([num | nums], coordinates, progress) do
    { new_progress, new_coordinate } = Progress.increment(progress, coordinates, num)
    do_build(nums, [new_coordinate | coordinates], new_progress)
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
    |> Board.build
    |> calculate_distance
  end

  defp calculate_distance([]), do: 0
  defp calculate_distance([%Coordinate{x: x, y: y} | _]), do: abs(x) + abs(y)
end
