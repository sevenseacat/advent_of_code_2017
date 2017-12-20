defmodule Advent.Day15.Generator do
  def new(initial, factor, divisor \\ nil) do
    Stream.unfold(initial, &({&1, next_val(&1, factor, divisor)}))
  end

  @doc """
  iex> Generator.next_val(65, 16807, nil)
  1092455

  iex> Generator.next_val(1092455, 16807, nil)
  1181022009

  iex> Generator.next_val(1181022009, 16807, nil)
  245556042

  iex> Generator.next_val(8921, 48271, nil)
  430625591

  iex> Generator.next_val(430625591, 48271, nil)
  1233683848

  iex> Generator.next_val(1233683848, 48271, nil)
  1431495498
  """
  def next_val(val, factor, nil) do
    rem(val * factor, 2_147_483_647)
  end

  def next_val(val, factor, divisor) do
    val = rem(val * factor, 2_147_483_647)
    if rem(val, divisor) != 0, do: next_val(val, factor, divisor), else: val
  end
end

defmodule Advent.Day15 do
  @part_1_pair_count 40_000_000
  @part_2_pair_count 5_000_000
  @a_factor 16807
  @b_factor 48271

  alias Advent.Day15.Generator

  @doc """
  iex> Day15.part1(65, 8921)
  588
  """
  def part1(a_initial, b_initial) do
    IO.puts "Calculating A hashes..."
    a_values = Generator.new(a_initial, @a_factor) |> Enum.take(@part_1_pair_count)
    IO.puts "Calculating B hashes..."
    b_values = Generator.new(b_initial, @b_factor) |> Enum.take(@part_1_pair_count)

    IO.puts "Comparing hashes..."
    count_matches(tl(a_values), tl(b_values), 0)
  end

  @doc """
  iex> Day15.part2(65, 8921)
  309
  """
  def part2(a_initial, b_initial) do
    IO.puts "Calculating A hashes..."
    a_values = Generator.new(a_initial, @a_factor, 4) |> Enum.take(@part_2_pair_count)
    IO.puts "Calculating B hashes..."
    b_values = Generator.new(b_initial, @b_factor, 8) |> Enum.take(@part_2_pair_count)

    IO.puts "Comparing hashes..."
    count_matches(tl(a_values), tl(b_values), 0)
  end

  defp count_matches([], [], count), do: count
  defp count_matches([a|a_values], [b|b_values], count) do
    <<a::little-16, _::binary>> = <<a::little-32>>
    <<b::little-16, _::binary>> = <<b::little-32>>

    count = if a == b, do: count + 1, else: count
    count_matches(a_values, b_values, count)
  end
end
