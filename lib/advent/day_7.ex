defmodule Advent.Day7.Program do
  alias __MODULE__

  defstruct name: nil, weight: 0, holding: [], stack_weight: 0

  def find(name, programs) do
    Enum.find(programs, &(&1.name == name))
  end

  def held_by_noone?(program, programs) do
    !Enum.any?(programs, fn p -> Enum.member?(p.holding, program.name) end)
  end

  def unbalanced_child_of(program, programs) do
    case balanced?(program, programs) do
      true ->
        nil

      false ->
        children = program_refs(program.holding, programs)
        Enum.find(children, &odd_stack_weight(&1, children))
    end
  end

  # A program is balanced if all of the programs it directly holds have the same stack weight.
  def balanced?(%Program{holding: []}, _), do: true

  def balanced?(%Program{holding: holding}, programs) do
    weights =
      program_refs(holding, programs)
      |> Enum.map(&Map.get(&1, :stack_weight))
      |> Enum.uniq()

    length(weights) == 1
  end

  def program_refs(names, programs) do
    Enum.map(names, &find(&1, programs))
  end

  def siblings(program, programs) do
    programs
    |> Enum.find(&Enum.member?(&1.holding, program.name))
    |> Map.get(:holding)
    |> Enum.reject(&(&1 == program.name))
    |> program_refs(programs)
  end

  defp odd_stack_weight(program, programs) do
    Enum.count(programs, &(&1.stack_weight == program.stack_weight)) == 1
  end
end

defmodule Advent.Day7 do
  alias Advent.Day7.Program

  def part1(programs) do
    programs
    |> Enum.find(&Program.held_by_noone?(&1, programs))
  end

  def part2(programs) do
    programs = Enum.map(programs, &assign_stack_weight(&1, programs))
    root = part1(programs)

    leaf = find_leaf(root, programs)
    siblings = Program.siblings(leaf, programs)
    calculate_difference(leaf, siblings)
  end

  defp find_leaf(unbalanced, programs) do
    case Program.unbalanced_child_of(unbalanced, programs) do
      nil -> unbalanced
      child -> find_leaf(child, programs)
    end
  end

  def parse_input(input) do
    programs =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&convert_to_program/1)

    programs
    |> Enum.map(&assign_stack_weight(&1, programs))
  end

  defp convert_to_program(input) do
    data = Regex.named_captures(~r/(?<name>\w+) \((?<weight>\d+)\)( -> (?<holding>.+))*/, input)

    %Program{
      name: data["name"],
      weight: String.to_integer(data["weight"]),
      holding: String.split(data["holding"], ", ", trim: true)
    }
  end

  def assign_stack_weight(program, programs) do
    %{program | stack_weight: calculate_stack_weight(program, programs)}
  end

  defp calculate_stack_weight(%Program{weight: weight, holding: []}, _), do: weight

  defp calculate_stack_weight(%Program{weight: weight, holding: holding}, programs) do
    weight +
      (holding
       |> Stream.map(&Program.find(&1, programs))
       |> Stream.map(&calculate_stack_weight(&1, programs))
       |> Enum.sum())
  end

  defp calculate_difference(program, siblings) do
    difference =
      siblings
      |> Enum.map(&(&1.stack_weight - program.stack_weight))
      |> Enum.find(&(&1 != 0))

    {program, difference}
  end

  def bench do
    Benchee.run(
      %{
        "day 7, part 1" => fn -> Advent.data(7, parse: true) |> part1() end,
        "day 7, part 2" => fn -> Advent.data(7, parse: true) |> part2() end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
