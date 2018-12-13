defmodule Advent.Day2 do
  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&to_ints/1)
    |> Enum.map(&part_1_line_value/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&to_ints/1)
    |> Enum.map(&part_2_line_value/1)
    |> Enum.sum()
  end

  defp to_ints(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp part_1_line_value(line) do
    Enum.max(line) - Enum.min(line)
  end

  defp part_2_line_value(line) do
    line
    |> Enum.sort()
    |> find_divisible([])
  end

  defp find_divisible([x | xs], ys) do
    case Enum.find(ys, fn y -> rem(x, y) == 0.0 end) do
      nil -> find_divisible(xs, [x | ys])
      y -> div(x, y)
    end
  end

  def bench do
    Benchee.run(
      %{
        "day 2, part 1" => fn -> Advent.data(2) |> part1() end,
        "day 2, part 2" => fn -> Advent.data(2) |> part2() end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
