defmodule Advent do
  alias Advent.{Day1, Day2, Day3, Day4, Day5, Day6, Day7, Day8, Day9, Day10, Day11, Day12, Day13}

  alias Advent.{Day14, Day15, Day16, Day17, Day18, Day182, Day19, Day20, Day21, Day22, Day23, Day24}

  alias Advent.{Day25}

  def data(day_no, opts \\ []) do
    filename = if opts[:test], do: "test/data/day_#{day_no}", else: "lib/advent/data/day_#{day_no}"

    data = File.read!(filename)

    if opts[:parse], do: apply(:"Elixir.Advent.Day#{day_no}", :parse_input, [data]), else: data
  end

  def run_all do
    [
      {1, 1, fn -> data(1) |> Day1.part1() end},
      {1, 2, fn -> data(1) |> Day1.part2() end},
      {2, 1, fn -> data(2) |> Day2.part1() end},
      {2, 2, fn -> data(2) |> Day2.part2() end},
      {3, 1, fn -> Day3.part1(277_678) end},
      {3, 2, fn -> Day3.part2(277_678) end},
      {4, 1, fn -> data(4) |> Day4.part1() end},
      {4, 2, fn -> data(4) |> Day4.part2() end},
      {5, 1, fn -> data(5, parse: true) |> Day5.part1() end},
      {5, 2, fn -> data(5, parse: true) |> Day5.part2() end},
      {6, "1+2", fn -> data(6, parse: true) |> Day6.parts() end},
      {7, 1, fn -> data(7, parse: true) |> Day7.part1() end},
      {7, 2, fn -> data(7, parse: true) |> Day7.part2() end},
      {8, 1, fn -> data(8) |> Day8.part1() end},
      {8, 2, fn -> data(8) |> Day8.part2() end},
      {9, "1+2", fn -> data(9) |> Day9.parts() end},
      {10, 1, fn -> data(10, parse: true) |> Day10.part1(Enum.to_list(0..255)) end},
      {10, 2, fn -> data(10) |> String.trim() |> Day10.part2() end},
      {11, 1, fn -> data(11) |> Day11.part1() end},
      {11, 2, fn -> data(11) |> Day11.part2() end},
      {12, 1, fn -> data(12, parse: true) |> Day12.part1(0) |> Enum.count() end},
      {12, 2, fn -> data(12, parse: true) |> Day12.part2() |> Enum.count() end},
      {13, 1, fn -> data(13, parse: true) |> Day13.part1() end},
      {13, 2, fn -> data(13, parse: true) |> Day13.part2() end},
      {14, 1, fn -> Day14.part1("nbysizxe", 128) end},
      {14, 2, fn -> Day14.part2("nbysizxe", 128) end},
      {15, 1, fn -> Day15.part1(634, 301) end},
      {15, 2, fn -> Day15.part2(634, 301) end},
      {16, 1, fn -> Day16.part1("abcdefghijklmnop", data(16, parse: true)) end},
      {16, 2, fn -> Day16.part2("abcdefghijklmnop", data(16, parse: true), 1_000_000_000) end},
      {17, 1, fn -> Day17.part1(386) end},
      {17, 2, fn -> Day17.part2(386) end},
      {18, 1, fn -> data(18, parse: true) |> Day18.part1() end},
      {18, 2, fn -> data(18) |> Day182.parse_input |> Day182.run() end},
      {19, 1, fn -> data(19, parse: true) |> Day19.part1() end},
      {19, 2, fn -> data(19, parse: true) |> Day19.part2() end},
      {20, 1, fn -> data(20, parse: true) |> Day20.part1() end},
      {20, 2, fn -> data(20, parse: true) |> Day20.part2() end},
      {21, 1, fn -> data(21) |> Day21.part1(5) end},
      {21, 2, fn -> data(21) |> Day21.part1(18) end},
      {22, 1, fn -> data(22) |> Day22.part1(10000) end},
      {22, 2, fn -> data(22) |> Day22.part2(10_000_000) end},
      {23, 1, fn -> data(23) |> Day23.part1() end}
    ]
    |> Enum.each(fn {day, part_no, fun} ->
      IO.puts("day #{day}, part #{part_no}: #{Benchmark.measure(fun) |> elem(0)}")
    end)
  end
end
