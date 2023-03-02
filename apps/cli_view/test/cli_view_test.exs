defmodule CLIViewTest do
  use ExUnit.Case
  doctest CLIView

  test "greets the world" do
    assert CLIView.hello() == :world
  end
end
