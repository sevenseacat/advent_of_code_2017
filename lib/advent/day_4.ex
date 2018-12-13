defmodule Advent.Day4 do
  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.filter(&valid_part1_passphrase?/1)
    |> Enum.count()
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.filter(&valid_part2_passphrase?/1)
    |> Enum.count()
  end

  @doc """
  iex> Day4.valid_part2_passphrase?("abcde fghij")
  true

  iex> Day4.valid_part2_passphrase?("abcde xyz ecdab")
  false

  iex> Day4.valid_part2_passphrase?("a ab abc abd abf abj")
  true

  iex> Day4.valid_part2_passphrase?("iiii oiii ooii oooi oooo")
  true

  iex> Day4.valid_part2_passphrase?("oiii ioii iioi iiio")
  false
  """
  def valid_part2_passphrase?(input) do
    words =
      input
      |> String.split()
      |> Stream.map(&String.to_charlist/1)
      |> Enum.map(&Enum.sort/1)

    length(Enum.uniq(words)) == length(words)
  end

  defp valid_part1_passphrase?(string) do
    words = String.split(string)
    length(Enum.uniq(words)) == length(words)
  end

  def bench do
    Benchee.run(
      %{
        "day 4, part 1" => fn -> Advent.data(4) |> part1() end,
        "day 4, part 2" => fn -> Advent.data(4) |> part2() end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
