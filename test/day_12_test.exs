defmodule Advent.Day12Test do
  use ExUnit.Case
  alias Advent.Day12
  doctest Advent.Day12

  test "input parsing" do
    output = File.read!("test/data/day_12") |> Day12.parse_input

    assert output == %{
      0 => [2],
      1 => [1],
      2 => [0, 3, 4],
      3 => [2, 4],
      4 => [2, 3, 6],
      5 => [6],
      6 => [4, 5]
    }
  end

  test "part 1" do
    assert Day12.part1(%{0 => [2], 1 => [1], 2 => [0, 3, 4], 3 => [2, 4], 4 => [2, 3, 6], 5 => [6], 6 => [4, 5]}, 0)
      == [0, 2, 3, 4, 5, 6]
  end

  test "part 2" do
    assert Day12.part2(%{0 => [2], 1 => [1], 2 => [0, 3, 4], 3 => [2, 4], 4 => [2, 3, 6], 5 => [6], 6 => [4, 5]})
      == [[0, 2, 3, 4, 5, 6], [1]]
  end
end
