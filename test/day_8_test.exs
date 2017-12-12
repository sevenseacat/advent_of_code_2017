defmodule Advent.Day8Test do
  use ExUnit.Case
  alias Advent.Day8
  doctest Advent.Day8

  test "part 1" do
    input = "b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10"

    assert Day8.part1(input) == {"a", 1}
  end
end
