# To run: File.read!("lib/advent/data/day_18") |> Advent.Day182.parse_input |> Advent.Day182.run
defmodule Advent.Day182.Program do
  use GenServer

  alias __MODULE__

  ### Public interface
  def new(name, initial_value, commands) do
    GenServer.start_link(
      __MODULE__,
      %{
        name: name,
        commands: commands,
        status: :running,
        data: initial_value,
        index: 0,
        queue: [],
        waiting_for: nil,
        other: nil,
        send_count: 0
      },
      name: name
    )
  end

  def add_references(a, b) do
    GenServer.cast(:a, {:set_other, b})
    GenServer.cast(:b, {:set_other, a})
  end

  def next_command(pid), do: GenServer.call(pid, :next_command)

  def waiting?(pid), do: GenServer.call(pid, :status) == :waiting

  def add_to_queue(pid, value), do: GenServer.call(pid, {:add_to_queue, value})

  def send_count(pid), do: GenServer.call(pid, :send_count)

  ### Callbacks

  def init(args), do: {:ok, args}

  def handle_call(:send_count, _from, state), do: {:reply, state.send_count, state}
  def handle_call(:status, _from, state), do: {:reply, state.status, state}

  # If waiting to receive, we process no other stuff.
  def handle_call(:next_command, _from, %{status: :waiting} = state) do
    {:reply, :ok, state}
  end

  def handle_call(:next_command, _from, state) do
    new_state = state |> get_command |> perform_command(state)
    {:reply, :ok, new_state}
  end

  def handle_call(
        {:add_to_queue, value},
        _from,
        %{status: :waiting, waiting_for: waiting_for, data: data} = state
      ) do
    data = Map.put(data, waiting_for, value)
    {:reply, :ok, %{state | status: :running, waiting_for: nil, data: data}}
  end

  def handle_call({:add_to_queue, value}, _from, state) do
    {:reply, :ok, Map.update!(state, :queue, &(&1 ++ [value]))}
  end

  def handle_cast({:set_other, other}, state) do
    {:noreply, %{state | other: other}}
  end

  ### Other internal code

  defp get_command(state), do: Enum.at(state.commands, state.index)

  defp perform_command({:add, one, two}, %{data: data} = state) do
    data = Map.update(data, one, two, &(&1 + v(data, two)))
    %{state | index: state.index + 1, data: data}
  end

  defp perform_command({:assign, one, two}, %{data: data} = state) do
    data = Map.put(data, one, v(data, two))
    %{state | index: state.index + 1, data: data}
  end

  defp perform_command({:multiply, one, two}, %{data: data} = state) do
    data = Map.update(data, one, 0, &(&1 * v(data, two)))
    %{state | index: state.index + 1, data: data}
  end

  defp perform_command({:modulo, one, two}, %{data: data} = state) do
    two = v(data, two)
    data = Map.update(data, one, 0, &rem(&1, two))
    %{state | index: state.index + 1, data: data}
  end

  defp perform_command({:send, one}, state) do
    Program.add_to_queue(state.other, v(state.data, one))
    %{state | index: state.index + 1, send_count: state.send_count + 1}
  end

  defp perform_command({:receive, one}, %{queue: queue, data: data} = state) do
    if queue == [] do
      # ah nooooooo
      %{state | status: :waiting, waiting_for: one, index: state.index + 1}
    else
      data = Map.put(data, one, hd(queue))
      %{state | data: data, queue: tl(queue), index: state.index + 1}
    end
  end

  defp perform_command({:jump, one, two}, %{data: data, index: index} = state) do
    offset = if v(data, one) > 0, do: v(data, two), else: 1
    %{state | index: index + offset}
  end

  defp v(_, val) when is_integer(val), do: val
  defp v(data, val), do: Map.get(data, val, 0)
end

defmodule Advent.Day182 do
  alias Advent.Day182.Program

  @doc """
  iex> Day182.run([{:send, 1}, {:send, 2}, {:send, :p}, {:receive, :a}, {:receive, :b},
  ...> {:receive, :c}, {:receive, :d}])
  [3, 3]
  """
  def run(cmds) do
    {:ok, a} = Program.new(:a, %{p: 0}, cmds)
    {:ok, b} = Program.new(:b, %{p: 1}, cmds)

    Program.add_references(a, b)

    do_run(a, b)
  end

  defp do_run(a, b) do
    Program.next_command(a)
    Program.next_command(b)

    # Exit case - deadlock, both programs are waiting to be sent something
    if Program.waiting?(a) && Program.waiting?(b) do
      [Program.send_count(a), Program.send_count(b)]
    else
      do_run(a, b)
    end
  end

  @doc """
  This is the same as the original Day18.parse_input/1, except sound/recover are now send/receive.

  iex> Day182.parse_input("set a 1
  ...>add a 2
  ...>mul a a
  ...>mod a 5
  ...>snd a
  ...>set a 0
  ...>rcv a
  ...>jgz a -1
  ...>set a 1
  ...>jgz a -2")
  [{:assign, :a, 1}, {:add, :a, 2}, {:multiply, :a, :a}, {:modulo, :a, 5}, {:send, :a},
   {:assign, :a, 0}, {:receive, :a}, {:jump, :a, -1}, {:assign, :a, 1}, {:jump, :a, -2}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(["snd", one]), do: {:send, String.to_atom(one)}
  defp parse_line(["rcv", one]), do: {:receive, String.to_atom(one)}

  defp parse_line([cmd, one, two]) do
    one =
      try do
        String.to_integer(one)
      rescue
        ArgumentError -> String.to_atom(one)
      end

    two =
      try do
        String.to_integer(two)
      rescue
        ArgumentError -> String.to_atom(two)
      end

    case cmd do
      "add" -> {:add, one, two}
      "mul" -> {:multiply, one, two}
      "mod" -> {:modulo, one, two}
      "set" -> {:assign, one, two}
      "jgz" -> {:jump, one, two}
    end
  end
end
