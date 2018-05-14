defmodule Advent.Day5 do
  @doc """
  iex> Day5.part1([0, 3, 0, 1, -3])
  5
  """
  def part1(input) do
    do_jumps(input, 0, length(input), 0, &add_one/1)
  end

  @doc """
  iex> Day5.part2([0, 3, 0, 1, -3])
  10
  """
  def part2(input) do
    do_jumps(input, 0, length(input), 0, &add_or_subtract/1)
  end

  defp do_jumps(_, position, length, move_no, _) when position >= length, do: move_no

  defp do_jumps(input, position, length, move_no, fun) do
    {next_input, next_position} = next_jump(input, position, fun)
    do_jumps(next_input, next_position, length, move_no + 1, fun)
  end

  @doc """
  iex> Day5.next_jump([0, 3, 0, 1, -3], 0, &Day5.add_one/1)
  {[1, 3, 0, 1, -3], 0}

  iex> Day5.next_jump([1, 3, 0, 1, -3], 0, &Day5.add_one/1)
  {[2, 3, 0, 1, -3], 1}

  iex> Day5.next_jump([2, 3, 0, 1, -3], 1, &Day5.add_one/1)
  {[2, 4, 0, 1, -3], 4}

  iex> Day5.next_jump([2, 4, 0, 1, -3], 4, &Day5.add_one/1)
  {[2, 4, 0, 1, -2], 1}

  iex> Day5.next_jump([2, 4, 0, 1, -2], 1, &Day5.add_one/1)
  {[2, 5, 0, 1, -2], 5}
  """
  def next_jump(input, position, fun) do
    {move, input} = List.pop_at(input, position)
    new_input = List.insert_at(input, position, fun.(move))

    {new_input, position + move}
  end

  def add_one(move), do: move + 1

  def add_or_subtract(move) do
    case move >= 3 do
      true -> move - 1
      false -> move + 1
    end
  end
end
