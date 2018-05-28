defmodule Advent.Day24Test do
  use ExUnit.Case
  alias Advent.Day24
  doctest Advent.Day24

  test "generates all possible bridges given example input" do
    pipes = [{0, 2}, {2, 2}, {2, 3}, {3, 4}, {3, 5}, {0, 1}, {10, 1}, {9, 10}]

    bridges = [
      [],
      [{0, 1}],
      [{0, 1}, {10, 1}],
      [{0, 1}, {10, 1}, {9, 10}],
      [{0, 2}],
      [{0, 2}, {2, 3}],
      [{0, 2}, {2, 3}, {3, 4}],
      [{0, 2}, {2, 3}, {3, 5}],
      [{0, 2}, {2, 2}],
      [{0, 2}, {2, 2}, {2, 3}],
      [{0, 2}, {2, 2}, {2, 3}, {3, 4}],
      [{0, 2}, {2, 2}, {2, 3}, {3, 5}]
    ]

    assert Enum.sort(Day24.build_bridges([], 0, pipes)) == Enum.sort(bridges)
  end
end
