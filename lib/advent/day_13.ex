defmodule Advent.Day13.Layer do
  alias __MODULE__

  defstruct range: nil, position: 0, caught: false, dir: :down

  def new([depth, range]) do
    {String.to_integer(depth), %Layer{range: String.to_integer(range)}}
  end

  def move_sentry(%Layer{range: range, position: pos, dir: dir}=layer) do
    new_pos = move(pos, dir)
    {dir, new_pos} = case end_of_range?(range, new_pos) do
      true ->
        dir = change_dir(dir)
        {dir, move(pos, dir)}
      false -> {dir, new_pos}
    end
    %{ layer | dir: dir, position: new_pos }
  end

  defp move(pos, :down), do: pos+1
  defp move(pos, :up),   do: pos-1

  defp end_of_range?(range, new_pos), do: new_pos < 0 || new_pos == range

  defp change_dir(:down), do: :up
  defp change_dir(:up),   do: :down
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
    |> run_gauntlet(layer_count)
    |> Enum.filter(fn {_, v} -> v.caught end)
    |> Enum.reduce(0, fn {k, v}, acc -> acc + k * v.range end)
  end

  @doc """
  iex> Day13.part2(%{0 => %Layer{range: 3}, 1 => %Layer{range: 2}, 4 => %Layer{range: 4},
  ...> 6 => %Layer{range: 4}})
  10
  """
  def part2(input) do
    layer_count = Map.keys(input) |> Enum.max

    Enum.reduce_while(0..5000000, input, fn i, input ->
      if input |> run_gauntlet(layer_count) |> Enum.all?(fn {_, v} -> v.caught == false end) do
        {:halt, i}
      else
        if rem(i, 1000) == 0 do
          IO.inspect i
        end
        {:cont, move_sentries(input)}
      end
    end)
  end

  defp run_gauntlet(input, layer_count) do
    move(input, 0, layer_count)
  end

  def move(input, current, last) when current > last, do: input
  def move(input, current, last) do
    input
    |> mark_caught!(current)
    |> move_sentries
    |> move(current+1, last)
  end

  defp mark_caught!(input, current) do
    case Map.has_key?(input, current) do
      true ->  Map.update!(input, current, &(%{&1 | caught: &1.position == 0}))
      false -> input
    end
  end

  defp move_sentries(input) do
    input
    |> Enum.map(fn {k, v} -> {k, Layer.move_sentry(v)} end)
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
