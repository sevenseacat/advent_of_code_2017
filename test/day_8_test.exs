defmodule Advent.Day8Test do
  use ExUnit.Case
  alias Advent.Day8
  doctest Advent.Day8

  test "part 1" do
    assert Day8.part1(File.read!("test/data/day_8")) == {"a", 1}
  end

  test "part 2" do
    assert Day8.part2(File.read!("test/data/day_8")) == {"c", 10}
  end
end
