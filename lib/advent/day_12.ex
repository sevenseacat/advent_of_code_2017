defmodule Advent.Day12 do
  def part1(input, subject) do
    find_all_connected(subject, input, [subject])
    |> Enum.uniq()
    |> Enum.sort()
  end

  # Answer from puzzle input - 209
  def part2(input) do
    Enum.reduce(Map.keys(input), {Map.keys(input), []}, fn subject, {to_see, groups} ->
      case subject in to_see do
        false ->
          {to_see, groups}

        true ->
          new_group = part1(input, subject)
          {to_see -- new_group, [new_group | groups]}
      end
    end)
    |> elem(1)
    |> Enum.reverse()
  end

  defp find_all_connected(subject, data, seen) do
    subject
    |> find_immediately_connected(data)
    |> Enum.reject(&Enum.member?(seen, &1))
    |> Enum.reduce(seen, &find_all_connected(&1, data, [&1 | &2]))
  end

  defp find_immediately_connected(subject, data) do
    Map.fetch!(data, subject) ++ find_indirectly_connected(subject, data)
  end

  defp find_indirectly_connected(subject, data) do
    data
    |> Enum.filter(fn {_, v} -> Enum.member?(v, subject) end)
    |> Enum.map(&elem(&1, 1))
    |> List.flatten()
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, &parse_line/2)
  end

  defp parse_line(line, acc) do
    [key, vals] = String.split(line, " <-> ", parts: 2)

    Map.put(
      acc,
      String.to_integer(key),
      String.split(vals, ", ") |> Enum.map(&String.to_integer/1)
    )
  end

  def bench do
    Benchee.run(
      %{
        "day 12, part 1" => fn -> Advent.data(12, parse: true) |> part1(0) |> Enum.count() end,
        "day 12, part 2" => fn -> Advent.data(12, parse: true) |> part2() |> Enum.count() end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
