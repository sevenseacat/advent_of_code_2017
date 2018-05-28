defmodule Advent.Day25Test do
  use ExUnit.Case
  alias Advent.Day25
  doctest Advent.Day25
  import Advent.Day25, only: [l: 1, r: 1]

  test "part 1 with the example data" do
    rules = %{A: {{1, &r/1, :B}, {0, &l/1, :B}}, B: {{1, &l/1, :A}, {1, &r/1, :A}}}

    assert Day25.part1(rules, 6) == 3
  end
end
