defmodule Advent.Day4Test do
  use ExUnit.Case
  alias Advent.Day4
  doctest Advent.Day4

  test "example part 1" do
    assert Day4.part1("aa bb cc dd ee\naa bb cc dd aa\naa bb cc dd aaa") == 2
  end
end
