defmodule RefereeTest do
  use ExUnit.Case
  doctest Referee

  test "greets the world" do
    assert Referee.hello() == :world
  end
end
