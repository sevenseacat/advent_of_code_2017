defmodule Advent.Day2 do
  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&to_ints/1)
    |> Enum.map(&part_1_line_value/1)
    |> Enum.sum
  end
  
  defp to_ints(line) do
    line
    |> String.split
    |> Enum.map(&String.to_integer/1)
  end

  defp part_1_line_value(line) do
    Enum.max(line) - Enum.min(line)
  end
end
