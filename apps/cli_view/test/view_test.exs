defmodule ViewTest do
  use ExUnit.Case
  import View
  import Board
  doctest View

  describe "displayBoard(board)" do
    test "starting position" do
      brd = Board.startingPosition()
      assert View.displayBoard(brd) == []
    end
  end

  describe " CLI display" do

  end
end
