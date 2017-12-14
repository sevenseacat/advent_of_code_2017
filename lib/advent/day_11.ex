defmodule Advent.Day11 do
  @doc """
  iex> Day11.part1("ne,ne,ne")
  3

  iex> Day11.part1("ne,ne,sw,sw")
  0

  iex> Day11.part1("ne,ne,s,s")
  2

  iex> Day11.part1("se,sw,se,sw,sw")
  3
  """
  def part1(input) do
    input
    |> String.trim
    |> String.split(",")
    |> reduce_by_hex({0, 0})
    |> calculate_distance
  end

  # To reduce 3 dimensions to 2 dimensions, a N move can be represented as a combined NE+NW move.
  defp reduce_by_hex([], position), do: position
  defp reduce_by_hex([move | moves], {nw, ne}) do
    new_position = case move do
      "nw" -> {nw+1, ne}
      "n"  -> {nw+1, ne+1}
      "ne" -> {nw, ne+1}
      "se" -> {nw-1, ne}
      "s"  -> {nw-1, ne-1}
      "sw" -> {nw, ne-1}
    end
    reduce_by_hex(moves, new_position)
  end

  def calculate_distance({nw, ne}), do: Enum.max([abs(nw), abs(ne)])
end
