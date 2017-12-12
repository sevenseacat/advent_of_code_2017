defmodule Advent.Day7Test do
  use ExUnit.Case
  alias Advent.Day7
  alias Advent.Day7.Program
  doctest Advent.Day7

  setup_all do
    programs = [%Program{name: "pbga", weight: 66, holding: []},
                %Program{name: "xhth", weight: 57, holding: []},
                %Program{name: "ebii", weight: 61, holding: []},
                %Program{name: "havc", weight: 66, holding: []},
                %Program{name: "ktlj", weight: 57, holding: []},
                %Program{name: "fwft", weight: 72, holding: ["ktlj", "cntj", "xhth"]},
                %Program{name: "qoyq", weight: 66, holding: []},
                %Program{name: "padx", weight: 45, holding: ["pbga", "havc", "qoyq"]},
                %Program{name: "tknk", weight: 41, holding: ["ugml", "padx", "fwft"]},
                %Program{name: "jptl", weight: 61, holding: []},
                %Program{name: "ugml", weight: 68, holding: ["gyxo", "ebii", "jptl"]},
                %Program{name: "gyxo", weight: 61, holding: []},
                %Program{name: "cntj", weight: 57, holding: []}]

    [programs: programs]
  end

  test "parsing the input", context do
    input = File.read!("test/data/day_7")
    assert Day7.parse_input(input) == context[:programs]
  end

  test "part 1", context do
    assert Day7.part1(context[:programs]) ==
      %Program{name: "tknk", weight: 41, holding: ["ugml", "padx", "fwft"]}
  end
end
