defmodule BoardTest do
  use ExUnit.Case
  doctest Board
  import Board

  describe "Board.makeBoard(_,_)" do
    test "make 3x3 board" do
      assert makeBoard(3, 3) == [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]
    end

    test "make 8 by 8 board" do
      assert makeBoard(8, 8) == [
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt]
             ]
    end

    test "make 5 by 5 board" do
      assert makeBoard(5, 5) == [
               [:mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt]
             ]
    end

    test "make 3 by 4 and 4 by 3 boards" do
      assert makeBoard(3, 4) == [
               [:mt, :mt, :mt],
               [:mt, :mt, :mt],
               [:mt, :mt, :mt],
               [:mt, :mt, :mt]
             ]

      assert makeBoard(4, 3) == [[:mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt]]
    end

    test "make sure argument bounds works, raise arg errors if outside 3 by 3 and 8 by 8 inclusive to things like 3 by 8 and 8 by 3" do
      assert_raise BoardError, fn ->
        makeBoard(2, 3)
      end

      assert_raise BoardError, fn ->
        makeBoard(3, 2)
      end

      assert_raise BoardError, fn ->
        makeBoard(9, 3)
      end

      assert_raise BoardError, fn ->
        makeBoard(3, 9)
      end
    end

    test "make sure zero and one raise arg errors" do
      assert_raise BoardError, fn ->
        makeBoard(0, 0)
      end

      assert_raise BoardError, fn ->
        makeBoard(1, 1)
      end
    end
  end

  # end of describe makeboard tests

  describe "private recMakeBoard(cols, rows)" do
    test "make empty boards" do
      assert recMakeBoard(1, 0) == []
      assert recMakeBoard(0, 0) == []
      assert recMakeBoard(0, 1) == []
      assert recMakeBoard(0, 6) == []
    end

    test "make 1 by 1 board" do
      assert recMakeBoard(1, 1) == [[:mt]]
    end

    test "make 2 by 1 boards and 1 by 2" do
      assert recMakeBoard(1, 2) == [[:mt], [:mt]]
      assert recMakeBoard(2, 1) == [[:mt, :mt]]
    end

    test "make 1 by 8 and 8 by 1" do
      assert recMakeBoard(1, 8) == [[:mt], [:mt], [:mt], [:mt], [:mt], [:mt], [:mt], [:mt]]
      assert recMakeBoard(8, 1) == [[:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt]]
    end

    test "make 8 by 8" do
      assert recMakeBoard(8, 8) == [
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt]
             ]
    end

    test " make absurdly long ones" do
      assert recMakeBoard(64, 1) == [
               [
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt
               ]
             ]

      assert recMakeBoard(64, 2) == [
               [
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt
               ],
               [
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt,
                 :mt
               ]
             ]
    end
  end

  # end of recMakeBoard(cols, rows) tests

  describe "Board.placePiece(board, location, pieceColor, pieceType) tests" do
    #setup "initialize all the various boards" do
    #  a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]
    #end

    test "invalid board passed in raises error" do
      assert_raise BoardError, fn ->
        placePiece([], {1, 1}, :orange, :pawn)
      end
    end

    test "invalid location passed in raises error" do
      assert catch_error(placePiece([[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]], {0, 1}, :orange, :knight))
      assert_raise ArgumentError, fn ->
        placePiece([[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]], {0, 1}, :orange, :knight)
      end
    end

    test "invalid color passed in raises error" do
      #assert placePiece([[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]], :bishop, {:a, 1}, :red) == []
      assert catch_error(placePiece([[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]], {:a, 1}, :red, :bishop))
      assert_raise ArgumentError, fn ->
        placePiece([[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]], {0, 1}, :orange, :knight)
      end
    end

    test "invalid pawn placement in rankupzone passed in raises error" do
      assert_raise BoardError, fn ->
        placePiece([[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]], {1, 1}, :blue, :pawn)
      end
    end

    test "invalid piece passed in raises error, invalid color as well" do
    #  assert placePiece([[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]], :unicorn, {:a, 1}, :red) == []
      assert_raise ArgumentError, fn ->
        placePiece([[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]], {:a, 1}, :red, :unicorn)
      end
      assert_raise ArgumentError, fn ->
        placePiece([[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]], {:a, 1}, :red, :rook)
      end
    end

    # TODO: test desired functionality of placePiece, not just errors

    test "place a bishop in the top left square {a, 1}" do
      a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]

      assert placePiece(a3x3, {:a, 1}, :orange, :bishop) == [
               [:mt, :mt, :mt],
               [:mt, :mt, :mt],
               [{:orange, :bishop}, :mt, :mt]
             ]
    end

    test "place queen on top right square {c, 3}" do
      a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]

      assert placePiece(a3x3, {:c, 3}, :blue, :queen) == [
               [:mt, :mt, {:blue, :queen}],
               [:mt, :mt, :mt],
               [:mt, :mt, :mt]
             ]
    end

    test "place knight on middle middle square" do
      a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]

      assert placePiece(a3x3, {:b, 2}, :orange, :knight) == [
               [:mt, :mt, :mt],
               [:mt, {:orange, :knight}, :mt],
               [:mt, :mt, :mt]
             ]
    end

    test "place rook on bottom left square" do
      a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]

      assert placePiece(a3x3, {:a, 1}, :blue, :rook) == [
               [:mt, :mt, :mt],
               [:mt, :mt, :mt],
               [{:blue,:rook}, :mt, :mt]
             ]
    end

    test "place king on bottom right square" do
      a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]

      assert placePiece(a3x3, {:c, 3}, :orange, :king) == [
               [:mt, :mt, {:orange,:king}],
               [:mt, :mt, :mt],
               [:mt, :mt, :mt]
             ]
    end

    test "place orange pawn on bottom left square" do
      a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]

      assert placePiece(a3x3, {:a, 1}, :orange, :pawn) == [
               [:mt, :mt, :mt],
               [:mt, :mt, :mt],
               [{:orange,:pawn}, :mt, :mt]
             ]
    end

    test "make sure putting an orange pawn in the rank up zone on the top middle raises error" do
      a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]

      assert_raise BoardError, fn ->
        # not [{:mt, {:pawn, :orange}, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]] because it would be the edge of the board and the pawn would have to rank up
        placePiece(a3x3, {:b, 3}, :orange, :pawn)
      end
    end

    test "make sure putting a blue pawn in the rank up zone on the bottom right raises error" do
      a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]

      assert_raise BoardError, fn ->
        # not [{:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, {:pawn, :blue}]] because it would be the edge of the board and the pawn would have to rank up
        placePiece(a3x3, {:c, 1}, :blue, :pawn)
      end
    end

    test "regression test for problem with adding pieces in row, then a pawn in a different row" do
      orange_pawns_constructed = [[:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [{:blue, :pawn}, :mt, :mt, :mt, :mt, :mt, :mt, :mt],[:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],[:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn}],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt]]

      blue_pieces_constructed = [[{:blue, :rook}, {:blue, :knight}, {:blue, :bishop}, {:blue, :queen}, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
        [{:blue, :pawn}, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, {:orange, :rook}]]

      just_blue_pieces_constructed = [[{:blue, :rook}, {:blue, :knight}, {:blue, :bishop}, {:blue, :queen}, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
        [{:blue, :pawn}, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt]]

      just_orange_pawns_placed = makeBoard(8,8)
      |> placePiece({:a, 2}, :orange, :pawn)
      |> placePiece({:b, 2}, :orange, :pawn)
      |> placePiece({:c, 2}, :orange, :pawn)
      |> placePiece({:d, 2}, :orange, :pawn)
      |> placePiece({:e, 2}, :orange, :pawn)
      |> placePiece({:f, 2}, :orange, :pawn)
      |> placePiece({:g, 2}, :orange, :pawn)
      |> placePiece({:h, 2}, :orange, :pawn)

      just_blue_pieces_placed = makeBoard(8,8)
      |> placePiece({:a, 8}, :blue, :rook)
      |> placePiece({:b, 8}, :blue, :knight)
      |> placePiece({:c, 8}, :blue, :bishop)
      |> placePiece({:d, 8}, :blue, :queen)
      |> placePiece({:e, 8}, :blue, :king)
      |> placePiece({:f, 8}, :blue, :bishop)
      |> placePiece({:g, 8}, :blue, :knight)
      |> placePiece({:h, 8}, :blue, :rook)
      |> placePiece({:a, 7}, :blue, :pawn)

      just_orange_pawns_constructed = [[:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],[:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],[:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn}],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt]]

      assert just_orange_pawns_constructed == just_orange_pawns_placed
      assert just_blue_pieces_constructed == just_blue_pieces_placed

      orange_pawns_placed = just_orange_pawns_placed
      |> placePiece({:a, 7}, :blue, :pawn)

      blue_pieces_placed = just_blue_pieces_placed
      |> placePiece({:h, 1}, :orange, :rook)

      assert orange_pawns_constructed == orange_pawns_placed
      assert blue_pieces_constructed == blue_pieces_placed
    end
  end

  # end of placePiece(board, piecetype, location, color)

  describe "Board.inRankUpZone(di)" do
    test "basic 3x3 board has rank up zone orange at top (so row 3) and rank up zone blue at bottom (so row 1)" do
      assert inRankUpZone({3, 3}, {3,1}, :orange) == false
      assert inRankUpZone({3,3}, {3,3}, :orange) == true
      assert inRankUpZone({3, 3}, {3,1}, :blue) == true
      assert inRankUpZone({3,3}, {3,3}, :blue) == false
      assert inRankUpZone({3, 3}, {3,2}, :blue) == false
      assert inRankUpZone({3,3}, {3,2}, :orange) == false
    end

    test "8x8 board has orange at top (rank 8), blue at bottom (rank/row 1)" do
      assert inRankUpZone({8, 8}, {6,1}, :orange) == false
      assert inRankUpZone({7,8}, {4,8}, :orange) == true
      assert inRankUpZone({6, 8}, {5,1}, :blue) == true
      assert inRankUpZone({5,8}, {4,8}, :blue) == false
      assert inRankUpZone({4, 8}, {3,6}, :blue) == false
      assert inRankUpZone({3,8}, {3,2}, :orange) == false
    end
  end

  describe "Board.boardSize(board) tests" do
    test "make sure boardsize works on 3 x 3" do
      assert boardSize([[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]) == {3, 3}
    end

    test "make sure boardsize works on 3 by 4" do
      assert boardSize([[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]) ==
               {3, 4}
    end

    test "boardsize works on 4 by 3" do
      assert boardSize([[:mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt]]) ==
               {4, 3}
    end

    # TODO: test errors of boardSize and oddballs
  end

  describe "fLocationIsEmpty(board, location) tests" do
    test "impossible boards" do
      assert fLocationIsEmpty([[:mt]], {:a,1}) == true
      assert fLocationIsEmpty([[:mt], [:mt]], {:a,2}) == true
      assert fLocationIsEmpty([[:mt, :mt], [:mt, :mt]], {:b,2}) == true
      assert fLocationIsEmpty([[:red, :mt], [:red, :mt]], {:b,2}) == true
      assert fLocationIsEmpty([[:red, :red], [:red, :mt]], {:b,2}) == false
      assert fLocationIsEmpty([[:red, :red], [:red, :mt]], {:b,1}) == true
    end

    test "real boards" do
      a3x3 = makeBoard(3,3)
      #a8x8 = makeBoard(8,8)

      assert fLocationIsEmpty(a3x3, {:b, 2}) == true
      assert fLocationIsEmpty([[:mt, :mt, :mt], [:mt, :notempty, :mt], [:mt, :mt, :mt]], {:b, 2}) == false
      assert fLocationIsEmpty([[:mt, :mt, :mt], [:mt, {:orange, :pawn}, :mt], [:mt, :mt, :mt]], {:b, 2}) == false
      assert fLocationIsEmpty([[:mt, :mt, :mt], [:mt, {:red, :pawn}, :mt], [:mt, :mt, :mt]], {:b, 2}) == false
      assert fLocationIsEmpty([[:mt, :mt, :mt], [:mt, {:blue, :unicorn}, :mt], [:mt, :mt, :mt]], {:b, 2}) == false
      assert fLocationIsEmpty([[:mt, :mt, :mt], [:mt, {:blue, :unicorn}, :mt], [:mt, :mt, :mt]], {:b, 1}) == true
      assert fLocationIsEmpty([[:mt, :mt, :mt], [:mt, {:blue, :unicorn}, :mt], [:mt, :mt, :mt]], {:b, 3}) == true

      #assert fLocationIsEmpty(move(a8x8, :orange, :pawn, :sprint, {:b, 1}), {:b, 3}) == false
    end
  end

  describe "Board.placeTile" do
    test "basic placeTile" do
      assert placeTile([], :orange, {:a, 1}) == [{:orange, {:a, 1}}]
      assert placeTile([{:blue, {:a, 1}}, {:orange, {:a, 3}}], :orange, {:a, 2}) == [{:blue, {:a, 1}}, {:orange, {:a, 3}}, {:orange, {:a, 2}}]
      assert placeTile([{:red, {:b, 2}}], :orange, {:b, 3}) == [{:red, {:b, 2}}, {:orange, {:b, 3}}]
    end

    test "placing a tile on an existing tile throws a board error" do
      assert catch_error(placeTile([{:red, {:b, 2}}], :orange, {:b, 2}))
      assert_raise BoardError, fn ->
        placeTile([{:red, {:b, 2}}], :orange, {:b, 2})
      end
      assert catch_error(placeTile([{:blue, {:d, 5}}], :blue, {:d, 5}))
      assert_raise BoardError, fn ->
        placeTile([{:blue, {:d, 5}}], :blue, {:d, 5})
      end
    end
  end

  describe "isReplacingTile(tileary, formal_location) tests" do
    test "handles an empty list" do
      assert isReplacingTile([], {:y, 3}) == false
      assert isReplacingTile([], {:h, 8}) == false
      assert isReplacingTile([], {}) == false
    end
    test "handles a small list" do
      assert isReplacingTile([{:red, {:a, 1}}], {:a, 1}) == true
      assert isReplacingTile([{:red, {:a, 1}}], {:a, 2}) == false

      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}], {:a, 2}) == false
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}], {:a, 1}) == true
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}], {:c, 1}) == false
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}], {:c, 4}) == true
    end

    test "handles a big list" do
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}], {:h, 8}) == false
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}], {:c, 8}) == false
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}], {:a, 2}) == false

      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}], {:c, 4}) == true
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}], {:a, 1}) == true
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}], {:c, 1}) == true

      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}, {:orange, {:h, 8}}], {:g,4}) == false
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}, {:orange, {:h, 8}}], {:c,4}) == true
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}, {:orange, {:h, 8}}], {:c,1}) == true
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}, {:orange, {:h, 8}}], {:h,8}) == true
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}, {:orange, {:h, 8}}], {:h,7}) == false
    end
  end

  # end of placeTile tests

  describe "Board.startingPosition" do
    test "basic starting position" do
      starting_board = [[{:blue, :rook}, {:blue, :knight}, {:blue, :bishop}, {:blue, :queen}, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
      [{:blue, :pawn},{:blue, :pawn},{:blue, :pawn},{:blue, :pawn},{:blue, :pawn},{:blue, :pawn},{:blue, :pawn},{:blue, :pawn}],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn},{:orange, :pawn}],
      [{:orange, :rook}, {:orange, :knight}, {:orange, :bishop}, {:orange, :queen}, {:orange, :king}, {:orange, :bishop}, {:orange, :knight}, {:orange, :rook}]]

      assert List.myers_difference(startingPosition(), starting_board) == [eq: starting_board]
      assert boardSize(startingPosition()) == {8,8}
      assert boardSize(starting_board) == {8,8}
      assert startingPosition() == starting_board
    end

    test "scotch starting position is equal whether got to through moves or placing pieces" do
      # hmm should i do moves where I just allow the moves through some unknown system to the outside user?
      # probably yes to conform to remote proxy pattern. This would entail not exposing the moveType to public functions
      # but I think I will still implement the moveType on the interior to keep things relatively simple
      # can just run through a list of possible moveTypes and ending locations and if there is one that is the same,
      # then allow the move to happen. This entails a move(:orange, :pawn, starting_location, ending_location) and
      # a function I will eventually make private that does something along the lines of
      # moveType(pieceType, pieceColor, starting_loc, ending_loc) and moveIsLegal(pieceType, pieceColor)
      # also a rankUpPawn function is needed, or some way to prompt the player who just promoted to select a pieceType to promote to
      # might just do another turn where the only legal move is rankup of that specific pawn?

      assert is_atom(:e)
      scotch = [
        [{:blue, :rook}, :mt, {:blue, :bishop}, {:blue, :queen}, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
        [{:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, :mt, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}],
        [:mt, :mt, {:blue, :knight}, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, {:blue, :pawn}, :mt, :mt, :mt],
        [:mt, :mt, :mt, {:orange, :pawn}, {:orange, :pawn}, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, {:orange, :knight}, :mt, :mt],
        [{:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, :mt, :mt, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}],
        [{:orange, :rook}, {:orange, :knight}, {:orange, :bishop}, {:orange, :queen}, {:orange, :king}, {:orange, :bishop}, :mt, {:orange, :rook}]
      ]
      scotch_moved = startingPosition()
      |> move({:e, 2}, {:e, 4}, :orange, :pawn) # or sprint
      |> move({:e, 7}, {:e, 5}, :blue, :pawn) # or :sprint
      |> move({:g, 1}, {:f, 3}, :orange, :knight) # or :leftvert
      |> move({:b, 8}, {:c, 6}, :blue, :knight)
      |> move({:d, 2}, {:d, 4}, :orange, :pawn)
      assert scotch == scotch_moved
      assert List.myers_difference(scotch, scotch_moved) == [eq: scotch]
    end
  end

  # end of startingPosition tests

  describe "Board.move" do
    test "basic move, lets say e4 as orange" do
    end

    test "a series of moves passed into each other, lets say the scotch opening" do
    end

    test "a series of moves passed into each other, lets say the scandinavian opening where queen moves to a5" do

      scandinavian = [
        [{:blue, :rook}, {:blue, :knight}, {:blue, :bishop}, :mt, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
        [{:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, :mt, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [{:blue, :queen}, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, {:orange, :knight}, :mt, :mt, :mt, :mt, :mt],
        [{:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, :mt, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}],
        [{:orange, :rook}, :mt, {:orange, :bishop}, {:orange, :queen}, {:orange, :king}, {:orange, :bishop}, {:orange, :knight}, {:orange, :rook}]
      ]
      scandinavian_moved = startingPosition()
      |> move({:e, 2}, {:e, 4}, :orange, :pawn)
      |> move({:d, 7}, {:d, 5}, :blue, :pawn)
      |> move({:e, 4}, {:d, 5}, :orange, :pawn)
      |> move({:d, 8}, {:d, 5}, :blue, :queen)
      |> move({:b, 1}, {:c, 3}, :orange, :knight)
      |> move({:d, 5}, {:a, 5}, :blue, :queen)

      assert List.myers_difference(scandinavian, scandinavian_moved) == [eq: scandinavian]
      assert scandinavian == scandinavian_moved
    end
  end

  # end of Board.move tests

  describe "createBoardInitial" do
    test "basic initial create board" do
    end
  end

  # end of Board.createBoardInitial

  describe "createBoard (intermediate)" do
    test "basic intermediate createBoard" do
    end
  end

  # end of Board.createBoard

  # TODO: find any private functions that are complicated and test here,
  # and identify things the rulechecker might use and test here

  describe "printBoard (board)" do
    test "startingposition" do
      assert printBoard(startingPosition()) == "♜♞♝♛♚♝♞♜\r♟︎♟︎♟︎♟︎♟︎♟︎♟︎♟︎\r◼◼◼◼◼◼◼◼\r◼◼◼◼◼◼◼◼\r◼◼◼◼◼◼◼◼\r◼◼◼◼◼◼◼◼\r♙♙♙♙♙♙♙♙\r♖♘♗♕♔♗♘♖\r"
    end
  end


  describe "listBoard (board)" do
    test "startingposition" do
      assert listBoard(startingPosition()) == [["♜","♞","♝","♛","♚","♝","♞","♜"],["♟︎","♟︎","♟︎","♟︎","♟︎","♟︎","♟︎","♟︎"],["◼","◼","◼","◼","◼","◼","◼","◼"],["◼","◼","◼","◼","◼","◼","◼","◼"],["◼","◼","◼","◼","◼","◼","◼","◼"],["◼","◼","◼","◼","◼","◼","◼","◼"],["♙","♙","♙","♙","♙","♙","♙","♙"],["♖","♘","♗","♕","♔","♗","♘","♖"]]
    end
  end
end

# end of module
