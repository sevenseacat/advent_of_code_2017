defmodule Advent.Day13.Layer do
  alias __MODULE__

  defstruct depth: 0, range: nil, position: 0, caught: false

  def new([depth, range]) do
    %Layer{depth: String.to_integer(depth), range: String.to_integer(range)}
  end

  def set_position(%Layer{range: range} = layer, offset) do
    # Remove loops in the process, ie. if offset is 8 and range is 3, then the offset can be reduced
    # by 4 because after 4 moves, the sentry will be back at its starting position
    offset = rem(offset, range * 2 - 2)
    new_pos = if offset >= range, do: offset - 2 - 2 * (offset - range), else: offset

    %{layer | position: new_pos}
  end
end

defmodule Advent.Day13 do
  alias Advent.Day13.Layer

  @doc """
  iex> Day13.part1([%Layer{depth: 0, range: 3}, %Layer{depth: 1, range: 2},
  ...> %Layer{depth: 4, range: 4}, %Layer{depth: 6, range: 4}])
  24
  """
  def part1(input) do
    layer_count = input |> List.last() |> Map.fetch!(:depth)

    input
    |> move(0, 0, layer_count)
    |> Enum.filter(& &1.caught)
    |> Enum.reduce(0, fn layer, acc -> acc + layer.depth * layer.range end)
  end

  @doc """
  iex> Day13.part2([%Layer{depth: 0, range: 3}, %Layer{depth: 1, range: 2},
  ...> %Layer{depth: 4, range: 4}, %Layer{depth: 6, range: 4}])
  10
  """
  def part2(input, offset \\ 1) do
    if clear_path?(input, offset) do
      offset
    else
      part2(input, offset + 1)
    end
  end

  # A clear path is one where no sentries are at the top while a packet is travelling through.
  # This means at layer 0, time offset, layer 1, time offset+1, etc.
  # A sentry is at the top if it has moved a multiple of (range * 2 - 2) times, eg.
  # range 2 -> 1, 0 = 2 movements
  # range 3 -> 1, 2, 1, 0 = 4 movements
  # range 4 -> 1, 2, 3, 2, 1, 0 = 6 movements
  # When factoring in the path the packet takes (layer depth)...
  defp clear_path?(input, offset) do
    Enum.all?(input, fn layer ->
      rem(offset + layer.depth, layer.range * 2 - 2) != 0
    end)
  end

  def move(input, _, current, last) when current > last, do: input

  def move(input, offset, current, last) do
    input
    |> move_sentries(current + offset)
    |> mark_caught!(current)
    |> move(offset, current + 1, last)
  end

  defp mark_caught!(input, current) do
    input
    |> Enum.map(fn layer ->
      if layer.depth == current do
        %{layer | caught: layer.position == 0}
      else
        layer
      end
    end)
  end

  defp move_sentries(input, offset) do
    Enum.map(input, &Layer.set_position(&1, offset))
  end

  @doc """
  iex> Day13.parse_input("0: 3
  ...>1: 2
  ...>4: 4
  ...>6: 4")
  [%Layer{depth: 0, range: 3}, %Layer{depth: 1, range: 2}, %Layer{depth: 4, range: 4},
  %Layer{depth: 6, range: 4}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(&Layer.new/1)
  end
end
