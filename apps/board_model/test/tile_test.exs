defmodule TileTest do
  use ExUnit.Case
  doctest Tile
  import Tile
  describe "Tile.renderTile(_,_)" do
    test "empty tiles render" do
      assert renderTile(:orange, :empty) == "◻"
      assert renderTile(:blue, :empty) == "◼"
    end

    test "King tiles render" do
      assert renderTile(:orange, :king) == "♔"
      assert renderTile(:blue, :king) == "♚"
    end

    test "Queen tiles render" do
      assert renderTile(:orange, :queen) == "♕"
      assert renderTile(:blue, :queen) == "♛"
    end

    test "rook tiles render" do
      assert renderTile(:orange, :rook) == "♖"
      assert renderTile(:blue, :rook) == "♜"
    end

    test "bishop tiles render" do
      assert renderTile(:orange, :bishop) == "♗"
      assert renderTile(:blue, :bishop) == "♝"
    end

    test "knight tiles render" do
      assert renderTile(:orange, :knight) == "♘"
      assert renderTile(:blue, :knight) == "♞"
    end

    test "pawn tiles render" do
      assert renderTile(:orange, :pawn) == "♙"
      assert renderTile(:blue, :pawn) == "♟︎"
    end

    test "invalid piece color obj, raises error" do
      assert_raise ArgumentError, fn ->
        renderTile([78], :pawn)
      end
    end

    test "invalid tile color obj raises error, empty tile" do
      assert_raise ArgumentError, fn ->
        renderTile({:cool, 8}, :empty)
      end
    end
    test "invalid tile color string raises error, empty tile" do
      assert_raise ArgumentError, fn ->
        renderTile("cool", :empty)
      end
    end

    test "invalid tile color atom raises error, empty tile" do
      assert_raise ArgumentError, fn ->
        renderTile(:red, :empty)
      end
    end

    test "invalid tile color atom, real piece, raises error" do
      assert_raise ArgumentError, fn ->
        renderTile(:red, :queen)
      end
    end

    test "invalid tile color obj, real piece, raises error" do
      assert_raise ArgumentError, fn ->
        renderTile({:orange}, :queen)
      end
    end

    test "valid color, invalid obj piece raise error" do
      assert_raise ArgumentError, "invalid piecetype", fn ->
        renderTile(:orange, :unicorn)
      end
    end

    test "valid blue color, invalid obj piece raise error" do
      assert_raise ArgumentError, fn ->
        renderTile(:blue, :unicorn)
      end
    end

    test "valid color, invalid piece obj raise error" do
      assert_raise ArgumentError, fn ->
        renderTile(:blue, {:king})
      end
    end

    test "invalid fn call, empty, raise error" do
      assert_raise ArgumentError, "invalid color", fn ->
        renderTile(1,2)
      end
    end
  end

  describe "Tile.externalTileRep(_),(_,_,_)" do

    test "empty blue tile, empty orange tile" do
      assert externalTileRep(:blue) == "{\"tileColor\":\"blue\",\"contains\":[]}"
      assert externalTileRep(:orange) == "{\"tileColor\":\"orange\",\"contains\":[]}"
    end

    test "all orange pieces on blue tile" do
      assert externalTileRep(:blue, :orange, :pawn) == "{\"tileColor\":\"blue\",\"contains\":[\"orange\", \"pawn\"]}"
      assert externalTileRep(:blue, :orange, :rook) == "{\"tileColor\":\"blue\",\"contains\":[\"orange\", \"rook\"]}"
      assert externalTileRep(:blue, :orange, :king) == "{\"tileColor\":\"blue\",\"contains\":[\"orange\", \"king\"]}"
      assert externalTileRep(:blue, :orange, :bishop) == "{\"tileColor\":\"blue\",\"contains\":[\"orange\", \"bishop\"]}"
      assert externalTileRep(:blue, :orange, :knight) == "{\"tileColor\":\"blue\",\"contains\":[\"orange\", \"knight\"]}"
      assert externalTileRep(:blue, :orange, :queen) == "{\"tileColor\":\"blue\",\"contains\":[\"orange\", \"queen\"]}"
    end

    test "all blue pieces on blue tile" do
      assert externalTileRep(:blue, :blue, :pawn) == "{\"tileColor\":\"blue\",\"contains\":[\"blue\", \"pawn\"]}"
      assert externalTileRep(:blue, :blue, :rook) == "{\"tileColor\":\"blue\",\"contains\":[\"blue\", \"rook\"]}"
      assert externalTileRep(:blue, :blue, :king) == "{\"tileColor\":\"blue\",\"contains\":[\"blue\", \"king\"]}"
      assert externalTileRep(:blue, :blue, :bishop) == "{\"tileColor\":\"blue\",\"contains\":[\"blue\", \"bishop\"]}"
      assert externalTileRep(:blue, :blue, :knight) == "{\"tileColor\":\"blue\",\"contains\":[\"blue\", \"knight\"]}"
      assert externalTileRep(:blue, :blue, :queen) == "{\"tileColor\":\"blue\",\"contains\":[\"blue\", \"queen\"]}"
    end

    test "blue piece on orange tile" do
      assert externalTileRep(:orange, :blue, :pawn) == "{\"tileColor\":\"orange\",\"contains\":[\"blue\", \"pawn\"]}"
    end

    test "orange pieces on orange tile" do
      assert externalTileRep(:orange, :orange, :king) == "{\"tileColor\":\"orange\",\"contains\":[\"orange\", \"king\"]}"
      assert externalTileRep(:orange, :orange, :rook) == "{\"tileColor\":\"orange\",\"contains\":[\"orange\", \"rook\"]}"
      assert externalTileRep(:orange, :orange, :bishop) == "{\"tileColor\":\"orange\",\"contains\":[\"orange\", \"bishop\"]}"
      assert externalTileRep(:orange, :orange, :knight) == "{\"tileColor\":\"orange\",\"contains\":[\"orange\", \"knight\"]}"
      assert externalTileRep(:orange, :orange, :queen) == "{\"tileColor\":\"orange\",\"contains\":[\"orange\", \"queen\"]}"
      assert externalTileRep(:orange, :orange, :pawn) == "{\"tileColor\":\"orange\",\"contains\":[\"orange\", \"pawn\"]}"

    end
  end
end
