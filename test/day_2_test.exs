defmodule Advent.Day2Test do
  use ExUnit.Case
  alias Advent.Day2
  doctest Advent.Day2

  test "example 1" do
    assert Day2.part1("5 1 9 5\n7 5 3\n2 4 6 8") == 18
  end
end
