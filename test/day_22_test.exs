defmodule Advent.Day22Test do
  use ExUnit.Case
  alias Advent.Day22
  doctest Advent.Day22

  describe "part1/2" do
    test "it works for the sample data" do
      assert Day22.part1("..#\n#..\n...", 7) == 5
      assert Day22.part1("..#\n#..\n...", 70) == 41
      assert Day22.part1("..#\n#..\n...", 10000) == 5587
    end
  end

  describe "parse_input/1" do
    test "it records the 'on' bits, counting from {0, 0} at the centre" do
      assert Day22.parse_input("..#\n#..\n...") == %{
               {-1, 1} => false,
               {0, 1} => false,
               {1, 1} => true,
               {-1, 0} => true,
               {0, 0} => false,
               {1, 0} => false,
               {-1, -1} => false,
               {0, -1} => false,
               {1, -1} => false
             }
    end
  end
end