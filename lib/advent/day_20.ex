defmodule Advent.Day20.Particle do
  alias __MODULE__

  defstruct id: nil, position: nil, velocity: nil, acceleration: nil

  def manhattan_acceleration(%Particle{acceleration: {x, y, z}}) do
    abs(x) + abs(y) + abs(z)
  end

  @doc """
  iex> Particle.move(%Particle{id: 0, position: {3, 0, 0}, velocity: {2, 0, 0}, acceleration: {-1, 0, 0}})
  %Particle{id: 0, position: {4, 0, 0}, velocity: {1, 0, 0}, acceleration: {-1, 0, 0}}
  """
  def move(
        %Particle{position: {x1, y1, z1}, velocity: {x2, y2, z2}, acceleration: {x3, y3, z3}} =
          particle
      ) do
    {x1, x2, x3} = move_axis(x1, x2, x3)
    {y1, y2, y3} = move_axis(y1, y2, y3)
    {z1, z2, z3} = move_axis(z1, z2, z3)
    %{particle | position: {x1, y1, z1}, velocity: {x2, y2, z2}, acceleration: {x3, y3, z3}}
  end

  defp move_axis(position, velocity, acceleration) do
    {position + (velocity + acceleration), velocity + acceleration, acceleration}
  end
end

defmodule Advent.Day20 do
  alias Advent.Day20.Particle

  @doc """
  iex> Day20.part1([%Particle{id: 0, position: {3, 0, 0}, velocity: {2, 0, 0}, acceleration: {-1, 0, 0}},
  ...> %Particle{id: 1, position: {4, 0, 0}, velocity: {0, 0, 0}, acceleration: {-2, 0, 0}}])
  0
  """
  def part1(input) do
    input
    |> Enum.min_by(&Particle.manhattan_acceleration(&1))
    |> Map.get(:id)
  end

  def part2(input, run_count \\ 1000), do: do_part2(input, run_count)

  defp do_part2(input, 0), do: length(input)
  defp do_part2(input, run_count), do: do_part2(tick(input), run_count - 1)

  def tick(input) do
    input
    |> Enum.map(&Particle.move/1)
    |> remove_collisions
  end

  def remove_collisions(input) do
    # Find all particles at the same position as any other particle by grouping them by position
    collided =
      input
      |> Enum.group_by(& &1.position)
      |> Stream.filter(fn {_, particles} -> length(particles) > 1 end)
      |> Enum.map(fn {_, particles} -> particles end)
      |> List.flatten()
      |> Enum.map(& &1.id)

    # And nuke those particles.
    Enum.reject(input, &Enum.member?(collided, &1.id))
  end

  @doc """
  iex> Day20.parse_input("p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>
  ...>p=<4,0,0>, v=<0,0,0>, a=<-2,0,0>")
  [%Particle{id: 0, position: {3, 0, 0}, velocity: {2, 0, 0}, acceleration: {-1, 0, 0}},
   %Particle{id: 1, position: {4, 0, 0}, velocity: {0, 0, 0}, acceleration: {-2, 0, 0}}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce({[], 0}, fn x, {acc, count} ->
      {[build_particle(x, count) | acc], count + 1}
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  defp build_particle(row, id) do
    data =
      String.split(row, ", ")
      |> Enum.map(&Regex.named_captures(~r/<(?<x>-*\d+),(?<y>-*\d+),(?<z>-*\d+)>/, &1))
      |> Enum.map(
        &{String.to_integer(&1["x"]), String.to_integer(&1["y"]), String.to_integer(&1["z"])}
      )

    %Particle{
      id: id,
      position: Enum.at(data, 0),
      velocity: Enum.at(data, 1),
      acceleration: Enum.at(data, 2)
    }
  end

  def bench do
    Benchee.run(
      %{
        "day 20, part 1" => fn -> Advent.data(20, parse: true) |> part1() end,
        "day 20, part 2" => fn -> Advent.data(20, parse: true) |> part2() end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
