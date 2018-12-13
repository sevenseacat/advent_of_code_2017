defmodule Advent.Day5 do
  @doc """
  iex> Day5.part1([0, 3, 0, 1, -3])
  5
  """
  def part1(input) do
    input
    |> :array.from_list()
    |> do_jumps(0, length(input), 0, &add_one/1)
  end

  @doc """
  iex> Day5.part2([0, 3, 0, 1, -3])
  10
  """
  def part2(input) do
    input
    |> :array.from_list()
    |> do_jumps(0, length(input), 0, &add_or_subtract/1)
  end

  defp do_jumps(_, position, length, move_no, _) when position >= length, do: move_no

  defp do_jumps(input, position, length, move_no, fun) do
    {next_input, next_position} = next_jump(input, position, fun)
    do_jumps(next_input, next_position, length, move_no + 1, fun)
  end

  @doc """
  iex> Day5.next_jump(:array.from_list([0, 3, 0, 1, -3]), 0, &Day5.add_one/1)
  {:array.from_list([1, 3, 0, 1, -3]), 0}

  iex> Day5.next_jump(:array.from_list([1, 3, 0, 1, -3]), 0, &Day5.add_one/1)
  {:array.from_list([2, 3, 0, 1, -3]), 1}

  iex> Day5.next_jump(:array.from_list([2, 3, 0, 1, -3]), 1, &Day5.add_one/1)
  {:array.from_list([2, 4, 0, 1, -3]), 4}

  iex> Day5.next_jump(:array.from_list([2, 4, 0, 1, -3]), 4, &Day5.add_one/1)
  {:array.from_list([2, 4, 0, 1, -2]), 1}

  iex> Day5.next_jump(:array.from_list([2, 4, 0, 1, -2]), 1, &Day5.add_one/1)
  {:array.from_list([2, 5, 0, 1, -2]), 5}
  """
  def next_jump(input, position, fun) do
    move = :array.get(position, input)
    new_input = :array.set(position, fun.(move), input)

    {new_input, position + move}
  end

  def add_one(move), do: move + 1

  def add_or_subtract(move) do
    case move >= 3 do
      true -> move - 1
      false -> move + 1
    end
  end

  def parse_input(data) do
    data
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def bench do
    Benchee.run(
      %{
        "day 5, part 1" => fn -> Advent.data(5, parse: true) |> part1() end,
        "day 5, part 2" => fn -> Advent.data(5, parse: true) |> part2() end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
