defmodule Advent.Day13.Layer do
  alias __MODULE__

  defstruct range: nil, position: 0, caught: false

  def new([depth, range]) do
    {String.to_integer(depth), %Layer{range: String.to_integer(range)}}
  end

  def set_position(%Layer{range: range}=layer, offset) do
    # Remove loops in the process, ie. if offset is 8 and range is 3, then the offset can be reduced
    # by 4 because after 4 moves, the sentry will be back at its starting position
    offset = rem(offset, range * 2 - 2)
    new_pos = if offset >= range, do: offset - 2 - (2 * (offset - range)), else: offset

    %{ layer | position: new_pos }
  end
end

defmodule Advent.Day13 do
  alias Advent.Day13.Layer

  @doc """
  iex> Day13.part1(%{0 => %Layer{range: 3}, 1 => %Layer{range: 2}, 4 => %Layer{range: 4},
  ...> 6 => %Layer{range: 4}})
  24
  """
  def part1(input) do
    layer_count = Map.keys(input) |> Enum.max

    input
    |> move(0, 0, layer_count)
    |> Enum.filter(fn {_, v} -> v.caught end)
    |> Enum.reduce(0, fn {k, v}, acc -> acc + k * v.range end)
  end

  @doc """
  iex> Day13.part2(%{0 => %Layer{range: 3}, 1 => %Layer{range: 2}, 4 => %Layer{range: 4},
  ...> 6 => %Layer{range: 4}})
  10
  """
  def part2(input) do
    do_part2(input, 0, Map.keys(input) |> Enum.max)
  end

  def do_part2(input, offset, layer_count) do
    if offset > 0 && rem(offset, 1000) == 0, do: IO.puts(offset)
    new_input = move(input, offset, 0, layer_count)

    if Enum.any?(new_input, fn {_, v} -> v.caught end) do
      do_part2(input, offset+1, layer_count)
    else
      offset
    end
  end

  def move(input, _, current, last) when current > last, do: input
  def move(input, offset, current, last) do
    input
    |> move_sentries(current + offset)
    |> mark_caught!(current)
    |> move(offset, current+1, last)
  end

  defp mark_caught!(input, current) do
    case Map.has_key?(input, current) do
      true ->  Map.update!(input, current, &(%{&1 | caught: &1.position == 0}))
      false -> input
    end
  end

  defp move_sentries(input, offset) do
    input
    |> Enum.map(fn {k, v} -> {k, Layer.set_position(v, offset)} end)
    |> Enum.into(%{})
  end

  @doc """
  iex> Day13.parse_input("0: 3
  ...>1: 2
  ...>4: 4
  ...>6: 4")
  %{0 => %Layer{range: 3}, 1 => %Layer{range: 2}, 4 => %Layer{range: 4}, 6 => %Layer{range: 4}}
  """
  def parse_input(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, ": ")))
    |> Enum.reduce(%{}, fn row, acc ->
      {depth, layer} = Layer.new(row)
      Map.put(acc, depth, layer)
    end)
  end
end
