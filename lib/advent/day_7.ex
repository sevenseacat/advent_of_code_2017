defmodule Advent.Day7.Program do
  alias __MODULE__

  defstruct name: nil, weight: 0, holding: []

  def find(name, programs) do
    Enum.find(programs, &(&1.name == name))
  end

  def held_by_noone?(program, programs) do
    !Enum.any?(programs, fn p -> Enum.member?(p.holding, program.name) end)
  end
end

defmodule Advent.Day7 do
  alias Advent.Day7.Program

  def part1(programs) do
    programs
    |> Enum.find(&(Program.held_by_noone?(&1, programs)))
  end

  def parse_input(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&convert_to_program/1)
  end

  defp convert_to_program(input) do
    data = Regex.named_captures(~r/(?<name>\w+) \((?<weight>\d+)\)( -> (?<holding>.+))*/, input)
    %Program{
      name: data["name"],
      weight: String.to_integer(data["weight"]),
      holding: String.split(data["holding"], ", ", trim: true)
    }
  end
end
