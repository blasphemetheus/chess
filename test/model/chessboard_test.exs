defmodule ChessboardTest do
  @moduledoc """
  Testing the Chessboard module in Model
  """
  use ExUnit.Case
  doctest Chessboard
  import Chessboard
  import Board.Utils
  require View.CLI

#   this should be checkmate
# ♖ ◻ ♗ ♕ ♔ ♗ ♘ ♖
# ♙ ♙ ♙ ♙ ♙ ♙ ♙ ◼
# ◼ ◻ ♘ ◻ ♝ ♝ ♟︎ ◻
# ♟︎ ♟︎ ♟︎ ◼ ◻ ♛ ◻ ♟︎
# ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
# ◻ ◼ ◻ ♟︎ ◻ ♟︎ ◻ ◼
# ♞ ♚ ◼ ◻ ♟︎ ◻ ◼ ♜
# ♜ ◼ ◻ ◼ ◻ ◼ ♞ ◼

# halfmove: 5
# ♖ ◻ ♗ ♕ ♔ ♗ ♘ ♖
# ♙ ♙ ♙ ♙ ♙ ♝ ♙ ◼
# ◼ ◻ ♘ ◻ ◼ ♝ ♟︎ ◻
# ♟︎ ♟︎ ♟︎ ◼ ◻ ♛ ◻ ♟︎
# ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
# ◻ ◼ ◻ ♟︎ ◻ ♟︎ ◻ ◼
# ♞ ♚ ◼ ◻ ♟︎ ◻ ◼ ♜
# ♜ ◼ ◻ ◼ ◻ ◼ ♞ ◼


#   this one should only have one possible move for blue
# ♖ ◻ ♗ ♕ ♔ ♗ ♘ ♖
# ♙ ♙ ♙ ◼ ♙ ♟︎ ◻ ◼
# ♟︎ ◻ ♘ ◻ ◼ ◻ ♜ ◻
# ◻ ♟︎ ◻ ♞ ◻ ◼ ◻ ♛
# ◼ ◻ ♟︎ ◻ ♚ ◻ ♟︎ ♟︎
# ◻ ◼ ♝ ♟︎ ◻ ◼ ◻ ◼
# ♝ ◻ ◼ ◻ ◼ ♟︎ ◼ ♞
# ◻ ◼ ◻ ◼ ◻ ◼ ♜ ◼

describe " debug based on scenic GUI findings" do
  test "castle not showing up in possible moves" do
    game = %GameRunner{
      board: %Chessboard{
        placements: [
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [
            {:blue, :pawn},
            {:orange, :queen},
            {:blue, :pawn},
            :mt,
            :mt,
            :mt,
            {:blue, :pawn},
            :mt
          ],
          [:mt, {:blue, :bishop}, :mt, :mt, :mt, {:blue, :king}, :mt, :mt],
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, {:blue, :pawn}],
          [
            :mt,
            {:orange, :pawn},
            :mt,
            {:orange, :pawn},
            :mt,
            :mt,
            :mt,
            {:blue, :knight}
          ],
          [:mt, :mt, {:orange, :pawn}, :mt, :mt, :mt, :mt, :mt],
          [
            {:orange, :pawn},
            :mt,
            :mt,
            :mt,
            :mt,
            {:orange, :pawn},
            {:orange, :pawn},
            {:orange, :pawn}
          ],
          [
            {:orange, :rook},
            {:orange, :knight},
            {:orange, :bishop},
            :mt,
            {:orange, :king},
            :mt,
            :mt,
            {:orange, :rook}
          ]
        ],
        order: [:orange, :blue],
        impale_square: :noimpale,
        first_castleable: :both,
        second_castleable: :neither,
        halfmove_clock: 1,
        fullmove_number: 22
      },
      turn: :orange,
      first: %Player{type: :computer, color: :orange, tag: "me", lvl: 1},
      second: %Player{type: :computer, color: :blue, tag: "you", lvl: 1},
      status: :in_progress,
      history: [],
      resolution: nil,
      reason: nil
    }
    {res, _board} = move(game.board, {:e, 1}, {:g, 1}, :orange, :king, :nopromote)
    assert res == :ok
  end
  test "king can't castle despite being able to castle?" do
    castle_game = %GameRunner{
      board: %Chessboard{
        placements: [
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, {:blue, :rook}],
          [
            {:blue, :pawn},
            :mt,
            :mt,
            :mt,
            :mt,
            {:blue, :pawn},
            {:blue, :pawn},
            {:blue, :pawn}
          ],
          [:mt, :mt, :mt, :mt, {:blue, :pawn}, :mt, :mt, :mt],
          [{:orange, :pawn}, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [:mt, {:blue, :king}, :mt, :mt, :mt, :mt, :mt, :mt],
          [:mt, :mt, :mt, :mt, :mt, :mt, {:orange, :pawn}, {:orange, :bishop}],
          [
            :mt,
            {:blue, :rook},
            :mt,
            {:orange, :pawn},
            :mt,
            {:orange, :pawn},
            :mt,
            {:orange, :pawn}
          ],
          [
            {:orange, :rook},
            :mt,
            :mt,
            :mt,
            {:orange, :king},
            :mt,
            :mt,
            {:orange, :rook}
          ]
        ],
        order: [:orange, :blue],
        impale_square: :noimpale,
        first_castleable: :both,
        second_castleable: :neither,
        halfmove_clock: 0,
        fullmove_number: 24
      },
      turn: :orange,
      first: %Player{type: :computer, color: :orange, tag: "me", lvl: 1},
      second: %Player{type: :computer, color: :blue, tag: "you", lvl: 1},
      status: :in_progress,
      history: [],
      resolution: nil,
      reason: nil
    }

    assert :ob == Moves.roll({:a, 5}, :orange, :left)
    assert {:b, 4} == Moves.roll({:a, 5}, :orange, :right)
    assert :ob == Moves.duck({:a, 5}, :orange, :left)
    assert {:b, 6} == Moves.duck({:a, 5}, :orange, :right)
    assert [{:b, 4}] == reject_ob([:ob, {:b, 4}])
    assert {:blue, :king} == Chessboard.get_at(castle_game.board.placements, {:b, 4})
    assert [{{:b, 4}, {:blue, :king}}] == process([{:b, 4}], fn {_loc, {_piececolor, :queen}} -> true
    {_loc, {_piececolor, :pawn}} -> false
    {_loc, {_piececolor, :knight}} -> false
    {_loc, {_piececolor, :king}} -> true
    {_loc, {_piececolor, :bishop}} -> true
    {_loc, {_piececolor, :rook}} -> false
  end, castle_game.board.placements)

    assert [{{:b, 4}, {:blue, :king}}] == peer_one_in_every_direction({:a, 5}, :orange, castle_game.board.placements)


    assert attackers_of(castle_game.board, {:a, 1}) == []
    assert attackers_of(castle_game.board, {:b, 2}) == []
    assert attackers_of(castle_game.board, {:a, 5}) == [{{:b, 4}, {:blue, :king}}, {{:a, 1}, {:orange, :rook}}]
    assert attackers_of(castle_game.board, {:a, 7}) == []
    assert attackers_of(castle_game.board, {:a, 1}) == []
    assert attackers_of(castle_game.board, {:b, 4}) == [{{:b, 2}, {:blue, :rook}}]


    assert {:e, 1} == findKing(castle_game.board.placements, :orange)
    assert {{:h, 3}, {:orange, :bishop}} == scan(:veerright, {:f, 1}, :orange, castle_game.board.placements, fn
      {_loc, {_piececolor, :queen}} -> true
      {_loc, {_piececolor, :pawn}} -> false
      {_loc, {_piececolor, :knight}} -> false
      {_loc, {_piececolor, :king}} -> false
      {_loc, {_piececolor, :bishop}} -> true
      {_loc, {_piececolor, :rook}} -> false
    end)

    attackers_o_king = [
      {{:d, 2}, {:orange, :pawn}},
      {{:f, 2}, {:orange, :pawn}},
      {{:h, 1}, {:orange, :rook}},
      {{:a, 1}, {:orange, :rook}},
    ]
    assert attackers_o_king == attackers_of(castle_game.board, {:e, 1})

    assert [] |> length == 0
    assert [] == reject_same_color(attackers_o_king, :orange)
    # assert [] == attackers_o_king |> Enum.filter(fn {_loc, {color, _ptype}} -> otherColor(color) == :orange end)

    assert false == kingThreatened(castle_game.board, :orange)
    assert true == kingCheckDoesntDisruptCastle(:shortcastle, castle_game.board, :orange)
    {res, _board} = move(castle_game.board, {:e, 1}, {:g, 1}, :orange, :king)
    assert res == :ok
    {res2, _board} = appraise_move(castle_game.board, {:e, 1}, {:g, 1}, {:orange, :king})
    assert res2 == :ok
    # each_unappraised = evaluate_each_unappraised([{{:e, 1}, {:g, 1}}], castle_game.board, {:orange, :king}, {:e, 1}, :orange)
    # my_answer = {{:g, 1}, {:ok, %Chessboard{}}}
    assert shortcastle: {:g, 1} in Moves.unappraised_moves(:orange, :king, {:e, 1})
    assert {{:e, 1}, {:g, 1}} in appraise_each_loc_placement_tuples_to_move_tuples_or_thruples(castle_game.board, {:e, 1}, :orange, :king)

    pos_moves_king_loc = Chessboard.possible_moves(castle_game.board, {:e, 1})

    assert {{:e, 1},{:g, 1}} in pos_moves_king_loc
  end
  test "promotion does not show up on the GUI, why?" do
    game = %GameRunner{
      board: %Chessboard{
        placements: [
          [
            {:blue, :rook},
            {:blue, :knight},
            :mt,
            {:blue, :queen},
            {:blue, :king},
            {:blue, :bishop},
            {:blue, :knight},
            {:blue, :rook}
          ],
          [
            {:blue, :pawn},
            :mt,
            {:orange, :pawn},
            {:blue, :bishop},
            :mt,
            {:blue, :pawn},
            {:blue, :pawn},
            {:blue, :pawn}
          ],
          [:mt, :mt, :mt, :mt, {:blue, :pawn}, :mt, :mt, :mt],
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [:mt, {:orange, :pawn}, :mt, {:orange, :pawn}, :mt, :mt, :mt, :mt],
          [{:orange, :bishop}, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [
            {:orange, :pawn},
            :mt,
            {:blue, :pawn},
            :mt,
            :mt,
            {:orange, :pawn},
            {:orange, :pawn},
            {:orange, :pawn}
          ],
          [
            {:orange, :rook},
            {:orange, :knight},
            :mt,
            {:orange, :queen},
            {:orange, :king},
            {:orange, :bishop},
            {:orange, :knight},
            {:orange, :rook}
          ]
        ],
        order: [:orange, :blue],
        impale_square: :noimpale,
        first_castleable: :both,
        second_castleable: :both,
        halfmove_clock: 2,
        fullmove_number: 9
      },
      turn: :orange,
      first: %Player{type: :computer, color: :orange, tag: "me", lvl: 1},
      second: %Player{type: :computer, color: :blue, tag: "you", lvl: 1},
      status: :in_progress,
      history: [],
      resolution: nil,
      reason: nil
    }

    pos_moves_loc = Chessboard.possible_moves(game.board, {:c, 7})
    pos_moves_loc_color = Chessboard.possible_moves(game.board, {:c, 7}, :orange)
    pos_moves_color = Chessboard.possible_moves_of_color(game.board, :orange)
    promote_march = {{:c, 7}, {:c, 8}, :knight}
    promote_capture = {{:c, 7}, {:d, 8}, :queen}

    assert promote_march in Chessboard.appraise_each_loc_placement_tuples_to_move_tuples_or_thruples(game.board, {:c, 7}, :orange, :pawn)
    assert promote_march in pos_moves_loc_color
    assert promote_march in pos_moves_loc
    assert promote_march in pos_moves_color

    assert promote_capture in Chessboard.appraise_each_loc_placement_tuples_to_move_tuples_or_thruples(game.board, {:c, 7}, :orange, :pawn)
    assert promote_capture in pos_moves_loc_color
    assert promote_capture in pos_moves_loc
    assert promote_capture in pos_moves_color

    assert true == Chessboard.move_requires_promotion?(:orange, :pawn, {:b, 8})

    assert Genomeur.Component.ChessPosition.at_least_one_promote_valid(game.board, {:c, 7}, {:c, 8}, :orange, :pawn)
    assert [:bishop, :knight, :rook, :queen] == Genomeur.Component.ChessPosition.evaluate_each_promote_option_for_move(game.board, {:c, 7}, {:c, 8}, :orange, :pawn)
  end
  test "en passant aka impalement shows up in possible moves" do
    game = %GameRunner{
      board: %Chessboard{
        placements: [
          [
            blue: :rook,
            blue: :knight,
            blue: :bishop,
            blue: :queen,
            blue: :king,
            blue: :bishop,
            blue: :knight,
            blue: :rook
          ],
          [
            {:blue, :pawn},
            {:blue, :pawn},
            {:blue, :pawn},
            :mt,
            :mt,
            {:blue, :pawn},
            {:blue, :pawn},
            {:blue, :pawn}
          ],
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [
            :mt,
            :mt,
            :mt,
            {:blue, :pawn},
            {:blue, :pawn},
            {:orange, :pawn},
            :mt,
            :mt
          ],
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [
            {:orange, :pawn},
            {:orange, :pawn},
            {:orange, :pawn},
            {:orange, :pawn},
            {:orange, :pawn},
            :mt,
            {:orange, :pawn},
            {:orange, :pawn}
          ],
          [
            orange: :rook,
            orange: :knight,
            orange: :bishop,
            orange: :queen,
            orange: :king,
            orange: :bishop,
            orange: :knight,
            orange: :rook
          ]
        ],
        order: [:orange, :blue],
        impale_square: {:e, 6},
        first_castleable: :both,
        second_castleable: :both,
        halfmove_clock: 0,
        fullmove_number: 3
      },
      turn: :orange,
      first: %Player{type: :computer, color: :orange, tag: "me", lvl: 1},
      second: %Player{type: :computer, color: :blue, tag: "you", lvl: 1},
      status: :in_progress,
      history: [],
      resolution: nil,
      reason: nil
    }

    #march_or_impale_left
    pos_moves_loc = Chessboard.possible_moves(game.board, {:f, 5})
    pos_moves_loc_color = Chessboard.possible_moves(game.board, {:f, 5}, :orange)
    pos_moves_color = Chessboard.possible_moves_of_color(game.board, :orange)
    en_passant_move = {{:f, 5}, {:e, 6}}
    _march_move = {{:f, 5}, {:f, 6}}

    assert {:ok,
      %Chessboard{placements: game.board.placements |> Chessboard.remove_at({:f, 5}) |> Chessboard.placePiece({:f, 6}, :orange, :pawn),
      impale_square: :noimpale, first_castleable: :both, second_castleable: :both, halfmove_clock: 0, fullmove_number: 3
      }} == appraise_move(game.board, {:f, 5}, {:f, 6}, {:orange, :pawn})

    assert true == diagonalMove({:f, 5}, {:e, 6})
    assert {:blue, :pawn} == behind_at(game.board.placements, {:e, 6}, :orange)
    assert true == in_front_of_enemy_pawn(game.board.placements, {:e, 6}, :orange)

    # assert "hi" == pawn_move_take_validation(game.board, {:f, 5}, {:e, 6}, :orange, {:orange, :pawn}, :mt, :nopromote)
    # assert "yes" == move(game.board, {:f, 5}, {:e, 6}, :orange, :pawn, :nopromote)
    assert {:ok,
    %Chessboard{placements: game.board.placements |> Chessboard.remove_at({:f, 5}) |> Chessboard.remove_at({:e, 5}) |> Chessboard.placePiece({:e, 6}, :orange, :pawn),
    impale_square: :noimpale, first_castleable: :both, second_castleable: :both, halfmove_clock: 0, fullmove_number: 3
    }} == appraise_move(game.board, {:f, 5}, {:e, 6}, {:orange, :pawn})
    # assert {:ok,
    #   %Chessboard{placements: game.board.placements |> Chessboard.remove_at({:f, 5}) |> Chessboard.remove_at({:e, 6}) |> Chessboard.placePiece({:e, 6}, :orange, :pawn),
    #   impale_square: :noimpale, first_castleable: :both, second_castleable: :both, halfmove_clock: 0, fullmove_number: 3
    #   }} == appraise_move(game.board, {:f, 5}, {:e, 6}, {:orange, :pawn})
    assert {:capture, {:e, 6}} in Moves.unappraised_moves(:orange, :pawn, {:f, 5})

    # assert 6 == evaluate_each_unappraised([{:capture, {:e, 6}}], game.board, {:orange, :pawn}, {:f, 5}, :orange)
    assert en_passant_move in Chessboard.appraise_each_loc_placement_tuples_to_move_tuples_or_thruples(game.board, {:f, 5}, :orange, :pawn)
    assert en_passant_move in pos_moves_loc_color
    assert en_passant_move in pos_moves_loc
    assert en_passant_move in pos_moves_color
  end
end

describe " debug endgame stalemate in place of checkmate" do

  test "breaks on promotecapture" do

    promote_capture_str =
"""
◼ ◻ ♖ ◻ ◼ ◻ ♔ ◻
◻ ♟︎ ◻ ◼ ♙ ◼ ♖ ◼
◼ ◻ ◼ ◻ ♟︎ ◻ ◼ ♟︎
◻ ◼ ◻ ◼ ◻ ♙ ◻ ◼
◼ ♘ ◼ ◻ ◼ ◻ ♙ ◻
◻ ◼ ◻ ◼ ◻ ♗ ♟︎ ◼
♙ ◻ ◼ ◻ ◼ ♕ ◼ ◻
◻ ◼ ♚ ♘ ◻ ◼ ◻ ◼
"""
      {res, _promote_capture} = %Chessboard{placements: promote_capture_str |> Parser.parseBoardFromString()}
      |> move({:b, 7}, {:c, 8}, :orange, :pawn, :knight)

      assert res == :ok
  end

  test "make sure insufficient material works" do

    two_horse_vs_pawn_bishop_str =
    """
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ♔ ◼ ♞ ◼
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ♞ ◻ ◼ ♗ ◼ ◻ ♙
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ◻ ◼ ♚ ◼
    """
    two_horse_vs_pawn_bishop = two_horse_vs_pawn_bishop_str |> instil()
    two_horse_vs_bishop_str =
    """
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ♔ ◼ ◻ ◼
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ♞ ◻ ◼ ♗ ◼ ◻ ♞
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ◻ ◼ ♚ ◼
    """
    two_horse_vs_bishop = two_horse_vs_bishop_str |> instil()
    two_horse_vs_king_str =
    """
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ♔ ◼ ◻ ◼
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ◻ ◼ ◻ ♞
    ◼ ◻ ◼ ♞ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ◻ ◼ ♚ ◼
    """
    two_horse_vs_king = two_horse_vs_king_str |> instil()
    one_horse_vs_king_str =
    """
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
    ◼ ◻ ◼ ◻ ◼ ♔ ◼ ◻
    ◻ ♞ ◻ ◼ ◻ ◼ ◻ ◼
    ◼ ◻ ◼ ◻ ◼ ◻ ♚ ◻
    ◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
    """
    one_horse_vs_king = one_horse_vs_king_str |> Chessboard.instil()
    #IO.inspect(one_horse_vs_king)
    one_horse_vs_bishop_str =
      """
      ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
      ◻ ◼ ◻ ◼ ♔ ◼ ◻ ◼
      ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
      ◻ ♞ ◻ ◼ ♗ ◼ ◻ ◼
      ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
      ◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
      ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
      ◻ ◼ ◻ ◼ ◻ ◼ ♚ ◼
      """
    one_horse_vs_bishop = one_horse_vs_bishop_str |> instil()

    knight = grab(two_horse_vs_bishop.placements, :orange, :knight) |> length()
    king = grab(two_horse_vs_bishop.placements, :orange, :king) |> length()
    total = grabColor(two_horse_vs_bishop.placements, :orange) |> length()

    assert king == 1
    assert total == 3
    assert knight == 2


    assert Chessboard.kingKnigBoardhtKnight(two_horse_vs_king.placements, :orange) == true
    assert Chessboard.kingKnightKnight(two_horse_vs_king.placements, :blue) == false

    assert Chessboard.kingKnightKnight(one_horse_vs_king.placements, :orange) == false
    assert Chessboard.kingKnightKnight(one_horse_vs_king.placements, :blue) == false

    assert Chessboard.justKing(one_horse_vs_king.placements, :blue) == true
    assert Chessboard.justKing(one_horse_vs_king.placements, :orange) == false

    assert Chessboard.badMaterial(one_horse_vs_king.placements, :blue) == true
    assert Chessboard.badMaterial(one_horse_vs_king.placements, :orange) == true

    assert Chessboard.badMaterial(one_horse_vs_bishop.placements, :blue) == true
    assert Chessboard.badMaterial(one_horse_vs_bishop.placements, :orange) == true

    assert Chessboard.badMaterial(two_horse_vs_king.placements, :blue) == true
    assert Chessboard.badMaterial(two_horse_vs_king.placements, :orange) == false

    assert one_horse_vs_king |> isInsufficientMaterial() == true
    assert two_horse_vs_king |> isInsufficientMaterial() == true
    assert two_horse_vs_bishop |> isInsufficientMaterial() == false
    assert two_horse_vs_pawn_bishop |> isInsufficientMaterial() == false
    assert one_horse_vs_bishop |> isInsufficientMaterial() == true
  end

  test "haha this is stalemate, i thought board was reversed and things were broken" do
    _context =
    """
    %Outcome{
      players: [
        %Player{type: :computer, color: :orange, tag: "jimbo", lvl: 1},
        %Player{type: :computer, color: :blue, tag: "jombo", lvl: 0}
      ],
      resolution: :drawn,
      reason: :stalemate,
      games: [],
      score: [0, 0]
    }
    iex(6)>
    """
    pawns_mobile_str =
"""
◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
◻ ◼ ◻ ◼ ◻ ♟︎ ◻ ♝
♙ ◻ ◼ ◻ ◼ ◻ ◼ ◻
♟︎ ◼ ◻ ◼ ◻ ◼ ♛ ◼
◼ ◻ ◼ ♚ ◼ ◻ ◼ ◻
◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
◼ ◻ ◼ ◻ ◼ ◻ ◼ ♙
◻ ◼ ◻ ◼ ◻ ◼ ◻ ♔
"""
    pawns_mobile = %Chessboard{placements: pawns_mobile_str |> Parser.parseBoardFromString()}
    assert {:blue, :pawn} == Chessboard.get_at(pawns_mobile.placements, {:a, 6})
    assert Chessboard.kingThreatened(pawns_mobile, :blue) == false


    assert possible_moves(pawns_mobile, {:h, 1}) == []
    assert Chessboard.kingImmobile(pawns_mobile, :blue) == true
    a_6 = Moves.unappraised_moves(:blue, :pawn, {:a, 6})
    assert a_6 == [{:march, {:a, 5}}, {:capture, {:b, 5}}]
    h_2 = Moves.unappraised_moves(:blue, :pawn, {:h, 2})
    assert h_2 == [
      {:march, {:h, 1}},
      {:capture, {:g, 1}},
      {:promote, {{:blue, :knight}, {:h, 1}}},
      {:promote, {{:blue, :rook}, {:h, 1}}},
      {:promote, {{:blue, :bishop}, {:h, 1}}},
      {:promote, {{:blue, :queen}, {:h, 1}}},
      {:capturepromote, {{:blue, :knight}, :ob}},
      {:capturepromote, {{:blue, :knight}, {:g, 1}}},
      {:capturepromote, {{:blue, :rook}, :ob}},
      {:capturepromote, {{:blue, :rook}, {:g, 1}}},
      {:capturepromote, {{:blue, :bishop}, :ob}},
      {:capturepromote, {{:blue, :bishop}, {:g, 1}}},
      {:capturepromote, {{:blue, :queen}, :ob}},
      {:capturepromote, {{:blue, :queen}, {:g, 1}}}
    ]

    #assert Chessboard.evaluate_each_unappraised()
    #assert Chessboard.appraise_each_loc_placement_tuples_to_move_tuples_or_thruples(pawns_mobile, {:h, 2}, :blue, :pawn) == [{{:h, 2}, {:h, 3}}]
    #assert Chessboard.appraise_each_loc_placement_tuples_to_move_tuples_or_thruples(pawns_mobile, {:a, 6}, :blue, :pawn) == [{{:a, 6}, {:a, 7}}]

    assert Chessboard.possible_moves_of_color(pawns_mobile, :blue) == []
    assert Chessboard.noPieceCanMove(pawns_mobile, :blue) == true
    assert Chessboard.isStalemate(pawns_mobile, :blue) == true
  end

  test "pawns can put the king in check" do
    _context =
"""
◼ ♖ ◼ ♕ ♔ ♗ ♘ ♖
♙ ♙ ♙ ♗ ♙ ♙ ♙ ◼
◼ ◻ ♟︎ ◻ ◼ ◻ ◼ ◻
♚ ◼ ◻ ◼ ◻ ◼ ◻ ◼
♟︎ ♟︎ ◼ ◻ ◼ ♟︎ ♟︎ ♟︎
◻ ◼ ♟︎ ♛ ♟︎ ◼ ◻ ◼
◼ ◻ ◼ ♝ ◼ ◻ ♜ ♜
◻ ◼ ◻ ◼ ♞ ◼ ◻ ◼

◼ ♖ ◼ ♕ ♔ ♗ ♘ ♖
♙ ♙ ♙ ♟︎ ♙ ♙ ♙ ◼
◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
♚ ◼ ◻ ◼ ◻ ◼ ◻ ◼
♟︎ ♟︎ ◼ ◻ ◼ ♟︎ ♟︎ ♟︎
◻ ◼ ♟︎ ♛ ♟︎ ◼ ◻ ◼
◼ ◻ ◼ ♝ ◼ ◻ ♜ ♜
◻ ◼ ◻ ◼ ♞ ◼ ◻ ◼

%Outcome{
  players: [
    %Player{type: :computer, color: :orange, tag: "_player_", lvl: 1},
    %Player{type: :computer, color: :blue, tag: "_opponent_", lvl: 0}
  ],
  resolution: :drawn,
  reason: :stalemate,
  games: [],
  score: [0, 0]
}
iex(49)>
"""
    pawn_checkmate_s =
"""
◼ ♖ ◼ ♕ ♔ ♗ ♘ ♖
♙ ♙ ♙ ♟︎ ♙ ♙ ♙ ◼
◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
♚ ◼ ◻ ◼ ◻ ◼ ◻ ◼
♟︎ ♟︎ ◼ ◻ ◼ ♟︎ ♟︎ ♟︎
◻ ◼ ♟︎ ♛ ♟︎ ◼ ◻ ◼
◼ ◻ ◼ ♝ ◼ ◻ ♜ ♜
◻ ◼ ◻ ◼ ♞ ◼ ◻ ◼
"""
    pawn_checkmate = %Chessboard{placements: pawn_checkmate_s |> Parser.parseBoardFromString()}
    threatening_moves = Chessboard.threatens(pawn_checkmate, :orange)

    assert Moves.unappraised_moves(:orange, :pawn, {:d, 7}) == [march: {:d, 8}, capture: {:c, 8}, capture: {:e, 8}, promote: {{:orange, :knight}, {:d, 8}}, promote: {{:orange, :rook}, {:d, 8}}, promote: {{:orange, :bishop}, {:d, 8}}, promote: {{:orange, :queen}, {:d, 8}}, capturepromote: {{:orange, :knight}, {:c, 8}}, capturepromote: {{:orange, :knight}, {:e, 8}}, capturepromote: {{:orange, :rook}, {:c, 8}}, capturepromote: {{:orange, :rook}, {:e, 8}}, capturepromote: {{:orange, :bishop}, {:c, 8}}, capturepromote: {{:orange, :bishop}, {:e, 8}}, capturepromote: {{:orange, :queen}, {:c, 8}}, capturepromote: {{:orange, :queen}, {:e, 8}}]

    assert possible_moves(pawn_checkmate, {:d, 7}, :orange) == [
      {{:d, 7}, {:e, 8}, :knight},
      {{:d, 7}, {:e, 8}, :rook},
      {{:d, 7}, {:e, 8}, :bishop},
      {{:d, 7}, {:e, 8}, :queen}
    ]

    assert grab_possible_moves([{{:d, 7}, {:orange, :pawn}}, {{:a, 5}, {:orange, :king}}], pawn_checkmate) == [[
      {{:d, 7}, {:e, 8}, :knight},
      {{:d, 7}, {:e, 8}, :rook},
      {{:d, 7}, {:e, 8}, :bishop},
      {{:d, 7}, {:e, 8}, :queen}
    ], [{{:a, 5}, {:b, 5}}]]


    # assert Chessboard.fetch_locations(pawn_checkmate.placements)
    # |> filter_location_placement_tuples_for_color(:orange)
    # |> grab_possible_moves(pawn_checkmate) == ""
    # |> infer_move_type_from_board(board)
    # |> throw_out_ob_and_remove_promote_type_and_filter_out_blocked(placements)
    # |> remove_move_onlies()
    # |> thruple_to_tuple_kill_movetype()

    assert threatening_moves == [{{:d, 7}, {:e, 8}}, {{:a, 5}, {:b, 5}}, {{:b, 4}, {:b, 5}}, {{:f, 4}, {:f, 5}}, {{:g, 4}, {:g, 5}}, {{:h, 4}, {:h, 5}}, {{:c, 3}, {:c, 4}}, {{:d, 3}, {:c, 4}}, {{:d, 3}, {:b, 5}}, {{:d, 3}, {:a, 6}}, {{:d, 3}, {:e, 4}}, {{:d, 3}, {:f, 5}}, {{:d, 3}, {:g, 6}}, {{:d, 3}, {:h, 7}}, {{:d, 3}, {:c, 2}}, {{:d, 3}, {:b, 1}}, {{:d, 3}, {:e, 2}}, {{:d, 3}, {:f, 1}}, {{:d, 3}, {:d, 4}}, {{:d, 3}, {:d, 5}}, {{:d, 3}, {:d, 6}}, {{:e, 3}, {:e, 4}}, {{:d, 2}, {:c, 1}}, {{:g, 2}, {:g, 3}}, {{:g, 2}, {:g, 1}}, {{:g, 2}, {:f, 2}}, {{:g, 2}, {:e, 2}}, {{:h, 2}, {:h, 3}}, {{:h, 2}, {:h, 1}}, {{:e, 1}, {:f, 3}}, {{:e, 1}, {:c, 2}}]
    assert {{:d, 7}, {:e, 8}} in threatening_moves
    #and {{:d, 7}, {:c, 8}} in threatening_moves

    threatened = threatening_moves |> Enum.map(&move_to_end_loc/1)
    assert threatened == [e: 8, b: 5, b: 5, f: 5, g: 5, h: 5, c: 4, c: 4, b: 5, a: 6, e: 4, f: 5, g: 6, h: 7, c: 2, b: 1, e: 2, f: 1, d: 4, d: 5, d: 6, e: 4, c: 1, g: 3, g: 1, f: 2, e: 2, h: 3, h: 1, f: 3, c: 2]
    assert findKing(pawn_checkmate.placements, :blue) == {:e, 8}
    assert Enum.member?(threatened, {:e, 8})

    assert Chessboard.isCheck(pawn_checkmate, :blue) == true

    assert {{:d, 8}, {:blue, :queen}} in Chessboard.fetch_locations(pawn_checkmate.placements, :blue)
    assert {:advance, {:d, 7}} in Moves.unappraised_moves(:blue, :queen, {:d, 8})

    assert evaluate_each_unappraised([{{:d, 8}, {:d, 7}}], pawn_checkmate, {:blue, :queen}, {:d, 8}, :blue)



    assert Chessboard.possible_moves_of_color(pawn_checkmate, :blue) == [{{:d, 8}, {:d, 7}}]
    assert Chessboard.isCheckmate(pawn_checkmate, :blue) == false
  end
  test "ensure pawns can promote, no stalemate if it's only option" do
    promote_only_str =
"""
◼ ◻ ♜ ◻ ◼ ◻ ◼ ◻
◻ ♟︎ ◻ ♔ ◻ ◼ ♟︎ ◼
◼ ◻ ♞ ♙ ◼ ♟︎ ♟︎ ◻
♚ ♟︎ ◻ ♟︎ ◻ ◼ ◻ ♙
◼ ◻ ◼ ◻ ◼ ◻ ◼ ♟︎
◻ ◼ ♝ ◼ ◻ ◼ ◻ ◼
◼ ◻ ◼ ◻ ♙ ◻ ◼ ◻
◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
"""
    promote_only = %Chessboard{placements: promote_only_str |> Parser.parseBoardFromString()}
    assert Chessboard.fetch_locations(promote_only.placements, :blue) == [{{:d, 7}, {:blue, :king}}, {{:d, 6}, {:blue, :pawn}}, {{:h, 5}, {:blue, :pawn}}, {{:e, 2}, {:blue, :pawn}}]
    assert Moves.unappraised_moves(:blue, :pawn, {:e, 2}) == [march: {:e, 1}, capture: {:f, 1}, capture: {:d, 1}, promote: {{:blue, :knight}, {:e, 1}}, promote: {{:blue, :rook}, {:e, 1}}, promote: {{:blue, :bishop}, {:e, 1}}, promote: {{:blue, :queen}, {:e, 1}}, capturepromote: {{:blue, :knight}, {:f, 1}}, capturepromote: {{:blue, :knight}, {:d, 1}}, capturepromote: {{:blue, :rook}, {:f, 1}}, capturepromote: {{:blue, :rook}, {:d, 1}}, capturepromote: {{:blue, :bishop}, {:f, 1}}, capturepromote: {{:blue, :bishop}, {:d, 1}}, capturepromote: {{:blue, :queen}, {:f, 1}}, capturepromote: {{:blue, :queen}, {:d, 1}}]

    rook = appraise_move(promote_only, {:e, 2}, {:e, 1}, {:blue, :pawn}, :rook)
    assert {:ok, _} = rook
    bishop = appraise_move(promote_only, {:e, 2}, {:e, 1}, {:blue, :pawn}, :bishop)
    assert {:ok, _} = bishop
    queen = appraise_move(promote_only, {:e, 2}, {:e, 1}, {:blue, :pawn}, :queen)
    assert {:ok, _} = queen
    knight = appraise_move(promote_only, {:e, 2}, {:e, 1}, {:blue, :pawn}, :knight)
    assert {:ok, _} = knight

    eval_each = Moves.unappraised_moves(:blue, :pawn, {:e, 2})
    |> evaluate_each_unappraised(promote_only, {:blue, :pawn}, {:e, 2}, :blue)
    assert eval_each |> is_list()

    assert appraise_each_loc_placement_tuples_to_move_tuples_or_thruples(promote_only, {:e, 2}, :blue, :pawn) == [{{:e, 2}, {:e, 1}, :knight}, {{:e, 2}, {:e, 1}, :rook}, {{:e, 2}, {:e, 1}, :bishop}, {{:e, 2}, {:e, 1}, :queen}]

    assert promote_only |> Chessboard.possible_moves_of_color(:blue) == [{{:e, 2}, {:e, 1}, :knight}, {{:e, 2}, {:e, 1}, :rook}, {{:e, 2}, {:e, 1}, :bishop}, {{:e, 2}, {:e, 1}, :queen}]
    assert promote_only |> Chessboard.noPieceCanMove(:blue) == false
    assert promote_only |> Chessboard.isStalemate(:blue) == false


  end
  test "function error when there is a move to recover from checkmate" do

# ♖ ◻ ♗ ♕ ♔ ♗ ♘ ♖
# ♙ ♙ ◻ ♞ ♙ ♙ ♙ ♙
# ◼ ◻ ♝ ◻ ◼ ♟︎ ◼ ♟︎
# ◻ ◼ ◻ ◼ ◻ ◼ ♛ ◼
# ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ◻ ♟︎ ♝
# ♞ ◼ ◻ ◼ ◻ ◼ ◻ ◼
# ◼ ◻ ♜ ◻ ◼ ◻ ◼ ◻
# ◻ ◼ ◻ ♜ ◻ ♚ ◻ ◼

# ♖ ♞ ♗ ♕ ♔ ♗ ♘ ♖
# ♙ ♙ ◻ ◼ ♙ ♙ ♙ ♙
# ◼ ◻ ♝ ◻ ◼ ♟︎ ◼ ♟︎
# ◻ ◼ ◻ ◼ ◻ ◼ ♛ ◼
# ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ◻ ♟︎ ♝
# ♞ ◼ ◻ ◼ ◻ ◼ ◻ ◼
# ◼ ◻ ♜ ◻ ◼ ◻ ◼ ◻
# ◻ ◼ ◻ ♜ ◻ ♚ ◻ ◼

# ** (FunctionClauseError) no function clause matching in anonymous fn/1 in Chessboard.noMovesResolvingCheck/2

#     The following arguments were given to anonymous fn/1 in Chessboard.noMovesResolvingCheck/2:

#         # 1
#         [{{:c, 8}, {:d, 7}}]

#     (board_model 0.1.0) lib/board.ex:1390: anonymous fn/1 in Chessboard.noMovesResolvingCheck/2
#     (elixir 1.14.4) lib/enum.ex:1658: Enum."-map/2-lists^map/1-0-"/2
#     (elixir 1.14.4) lib/enum.ex:1658: Enum."-map/2-lists^map/1-0-"/2
#     (board_model 0.1.0) lib/board.ex:1390: Chessboard.noMovesResolvingCheck/2
#     (board_model 0.1.0) lib/board.ex:1284: Chessboard.isOver/2
#     (controller 0.1.0) lib/game.ex:231: GameRunner.takeTurns/1
#     (controller 0.1.0) lib/game.ex:104: GameRunner.runGame/2
# iex(6)>

    checkmated_str =
"""
♖ ♞ ♗ ♕ ♔ ♗ ♘ ♖
♙ ♙ ◻ ◼ ♙ ♙ ♙ ♙
◼ ◻ ♝ ◻ ◼ ♟︎ ◼ ♟︎
◻ ◼ ◻ ◼ ◻ ◼ ♛ ◼
♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ◻ ♟︎ ♝
♞ ◼ ◻ ◼ ◻ ◼ ◻ ◼
◼ ◻ ♜ ◻ ◼ ◻ ◼ ◻
◻ ◼ ◻ ♜ ◻ ♚ ◻ ◼
"""
    checkmated = %Chessboard{placements: checkmated_str |> Parser.parseBoardFromString()}
    assert Chessboard.noMovesResolvingCheck(checkmated, :blue) == false

    checkmated2_str =
"""
◼ ◻ ◼ ◻ ♕ ♗ ♘ ♖
◻ ♟︎ ◻ ◼ ♙ ◼ ◻ ♙
◼ ♟︎ ◼ ◻ ◼ ◻ ♔ ♟︎
◻ ◼ ◻ ◼ ◻ ◼ ♟︎ ♝
◼ ◻ ♟︎ ♟︎ ◼ ♟︎ ◼ ◻
◻ ◼ ♜ ◼ ◻ ◼ ♚ ♛
◼ ◻ ◼ ♞ ◼ ◻ ◼ ◻
◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
"""
    checkmated2 = %Chessboard{placements: checkmated2_str |> Parser.parseBoardFromString()}
    assert checkmated2 |> Chessboard.isCheckmate(:blue) == true

    one_move_str =
"""
◼ ◻ ♗ ♔ ◼ ◻ ♘ ♖
♙ ♖ ♕ ♜ ♙ ♟︎ ♝ ♙
◼ ♞ ♘ ◻ ◼ ♟︎ ♟︎ ♟︎
◻ ♟︎ ♟︎ ◼ ♛ ◼ ◻ ◼
◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
◻ ◼ ◻ ♞ ◻ ◼ ◻ ◼
◼ ◻ ♜ ♟︎ ♚ ◻ ◼ ◻
◻ ◼ ◻ ◼ ◻ ◼ ◻ ♝
"""
    one_move = %Chessboard{placements: one_move_str |> Parser.parseBoardFromString()}

    assert one_move |> Chessboard.noMovesResolvingCheck(:blue) == false
    assert one_move |> Chessboard.isCheckmate(:blue) == false

  end
  test "stalemate when should be checkmate " do

    _context =
    """
    ◼ ♖ ♗ ♕ ♔ ♗ ♘ ♖
    ♙ ♙ ◻ ♙ ♙ ♙ ♛ ♙
    ◼ ◻ ◼ ♟︎ ◼ ◻ ♞ ◻
    ◻ ◼ ♝ ♟︎ ◻ ♟︎ ♟︎ ◼
    ♟︎ ♟︎ ♟︎ ◻ ◼ ◻ ◼ ◻
    ♜ ◼ ♜ ◼ ◻ ◼ ◻ ♟︎
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ♚ ◻ ◼ ◻ ♝

    ◼ ♖ ♗ ♕ ♔ ♛ ♘ ♖
    ♙ ♙ ◻ ♙ ♙ ♙ ◻ ♙
    ◼ ◻ ◼ ♟︎ ◼ ◻ ♞ ◻
    ◻ ◼ ♝ ♟︎ ◻ ♟︎ ♟︎ ◼
    ♟︎ ♟︎ ♟︎ ◻ ◼ ◻ ◼ ◻
    ♜ ◼ ♜ ◼ ◻ ◼ ◻ ♟︎
    ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
    ◻ ◼ ◻ ♚ ◻ ◼ ◻ ♝
    """
    placements = [
      [:mt, {:blue, :rook}, {:blue, :bishop}, {:blue, :queen}, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
      [{:blue, :pawn}, {:blue, :pawn}, :mt, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:orange, :queen}, {:blue, :pawn}],
      [:mt, :mt, :mt, {:orange, :pawn}, :mt, :mt, {:orange, :knight}, :mt],
      [:mt, :mt, {:orange, :bishop}, {:orange, :pawn}, :mt, {:orange, :pawn}, {:orange, :pawn}, :mt],
      [{:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, :mt, :mt, :mt, :mt, :mt],
      [{:orange, :rook}, :mt, {:orange, :rook}, :mt, :mt, :mt, :mt, {:orange, :pawn}],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, {:orange, :king}, :mt, :mt, :mt, {:orange, :bishop}]
    ]
    start = %Chessboard{placements: placements}
    #View.CLI.showGameBoardAs(start, :orange)
    assert Chessboard.isCheck(start, :orange) == false
    assert Chessboard.isCheck(start, :blue) == false

    {res, checkmate} = Chessboard.move(start, {:g, 7}, {:f, 8}, :orange, :queen, :nopromote)
    assert checkmate |> is_struct()
    assert res == :ok
    assert Chessboard.kingImmobile(checkmate, :blue) == true
    threatening_moves = threatens(checkmate, :orange)
    threatened = threatening_moves |> Enum.map(&move_to_end_loc/1)
    assert {{:f, 8}, {:e, 8}} in threatening_moves
    assert findKing(checkmate.placements, :blue) == {:e, 8}
    assert {:e, 8} in threatened

    assert Chessboard.isCheck(checkmate, :blue) == true
    assert Chessboard.isStalemate(checkmate, :blue) == false
    assert Chessboard.kingImmobile(checkmate, :blue) == true # done
    assert Chessboard.possible_moves(checkmate, {:e, 8}, :blue) == []
    assert Chessboard.fetch_locations(checkmate.placements, :blue) == [
      {{:b, 8}, {:blue, :rook}},
      {{:c, 8}, {:blue, :bishop}},
      {{:d, 8}, {:blue, :queen}},
      {{:e, 8}, {:blue, :king}},
      {{:g, 8}, {:blue, :knight}},
      {{:h, 8}, {:blue, :rook}},
      {{:a, 7}, {:blue, :pawn}},
      {{:b, 7}, {:blue, :pawn}},
      {{:d, 7}, {:blue, :pawn}},
      {{:e, 7}, {:blue, :pawn}},
      {{:f, 7}, {:blue, :pawn}},
      {{:h, 7}, {:blue, :pawn}}
    ]


    assert Chessboard.noMovesResolvingCheck(checkmate, :blue) == true # todo
    assert Chessboard.isCheckmate(checkmate, :blue)


    _contextt =
"""
♖ ◻ ♗ ♕ ♔ ♗ ♘ ♖
♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙
◼ ◻ ♘ ◻ ♟︎ ◻ ◼ ◻
◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
♞ ◻ ♝ ◻ ♞ ◻ ◼ ◻
♟︎ ◼ ◻ ◼ ◻ ◼ ♟︎ ◼
◼ ♟︎ ♟︎ ♟︎ ♛ ♟︎ ◼ ♟︎
◻ ♜ ♝ ◼ ♚ ◼ ◻ ♜

♖ ◻ ♗ ♕ ♔ ♗ ♘ ♖
♙ ♙ ♙ ♙ ♙ ♟︎ ♙ ♙
◼ ◻ ♘ ◻ ◼ ◻ ◼ ◻
◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
♞ ◻ ♝ ◻ ♞ ◻ ◼ ◻
♟︎ ◼ ◻ ◼ ◻ ◼ ♟︎ ◼
◼ ♟︎ ♟︎ ♟︎ ♛ ♟︎ ◼ ♟︎
◻ ♜ ♝ ◼ ♚ ◼ ◻ ♜
"""

  end

  test "check stalemates registered as checkmates get fixed" do
    almost_checkmate =
"""
♖ ◻ ♗ ♕ ◼ ♗ ♘ ◻
♙ ♙ ◻ ♙ ◻ ♝ ♙ ♙
♟︎ ◻ ♟︎ ♟︎ ◼ ♔ ◼ ♞
◻ ♟︎ ◻ ◼ ♞ ◼ ◻ ◼
◼ ◻ ◼ ♜ ♟︎ ♟︎ ♟︎ ◻
◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
◼ ◻ ◼ ◻ ◼ ◻ ◼ ♟︎
◻ ◼ ◻ ◼ ♚ ♜ ◻ ◼
"""

parsed_placements_almost = almost_checkmate |> Parser.parseBoardFromString()
assert parsed_placements_almost == [
  [{:blue, :rook}, :mt, {:blue, :bishop}, {:blue, :queen}, :mt, {:blue, :bishop}, {:blue, :knight}, :mt],
  [{:blue, :pawn}, {:blue, :pawn}, :mt, {:blue, :pawn}, :mt, {:orange, :bishop}, {:blue, :pawn}, {:blue, :pawn}],
  [{:orange, :pawn}, :mt, {:orange, :pawn}, {:orange, :pawn}, :mt, {:blue, :king}, :mt, {:orange, :knight}],
  [:mt, {:orange, :pawn}, :mt, :mt, {:orange, :knight}, :mt, :mt, :mt],
  [:mt, :mt, :mt, {:orange, :rook}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, :mt],
  [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
  [:mt, :mt, :mt, :mt, :mt, :mt, :mt, {:orange, :pawn}],
  [:mt, :mt, :mt, :mt, {:orange, :king}, {:orange, :rook}, :mt, :mt]
]
parsed_almost = %Chessboard{placements: parsed_placements_almost}
assert kingImmobile(parsed_almost, :blue) == true
assert placementAgreesWithProvidedInfo({:orange, :knight}, :orange, :knight) == true

{res, checkmated_moved} = Chessboard.move(parsed_almost, {:h, 6}, {:g, 8}, :orange, :knight, :nopromote)
assert res == :ok

    checkmated =
"""
♖ ◻ ♗ ♕ ◼ ♗ ♞ ◻
♙ ♙ ◻ ♙ ◻ ♝ ♙ ♙
♟︎ ◻ ♟︎ ♟︎ ◼ ♔ ◼ ◻
◻ ♟︎ ◻ ◼ ♞ ◼ ◻ ◼
◼ ◻ ◼ ♜ ♟︎ ♟︎ ♟︎ ◻
◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
◼ ◻ ◼ ◻ ◼ ◻ ◼ ♟︎
◻ ◼ ◻ ◼ ♚ ♜ ◻ ◼
"""
    parsed_placements_checkmated = checkmated |> Parser.parseBoardFromString()
    assert parsed_placements_checkmated == [
      [{:blue, :rook}, :mt, {:blue, :bishop}, {:blue, :queen}, :mt, {:blue, :bishop}, {:orange, :knight}, :mt],
      [{:blue, :pawn}, {:blue, :pawn}, :mt, {:blue, :pawn}, :mt, {:orange, :bishop}, {:blue, :pawn}, {:blue, :pawn}],
      [{:orange, :pawn}, :mt, {:orange, :pawn}, {:orange, :pawn}, :mt, {:blue, :king}, :mt, :mt],
      [:mt, {:orange, :pawn}, :mt, :mt, {:orange, :knight}, :mt, :mt, :mt],
      [:mt, :mt, :mt, {:orange, :rook}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, {:orange, :pawn}],
      [:mt, :mt, :mt, :mt, {:orange, :king}, {:orange, :rook}, :mt, :mt]
    ]
    parsed_checkmated = %Chessboard{placements: parsed_placements_checkmated}
    assert kingImmobile(parsed_checkmated, :blue) == true
    assert noMovesResolvingCheck(parsed_checkmated, :blue)

    parsed_checkmate_locs = [
      {{:a, 8}, {:blue, :rook}},
      {{:b, 8}, :mt},
      {{:c, 8}, {:blue, :bishop}},
      {{:d, 8}, {:blue, :queen}},
      {{:e, 8}, :mt},
      {{:f, 8}, {:blue, :bishop}},
      {{:g, 8}, {:orange, :knight}},
      {{:h, 8}, :mt},
      {{:a, 7}, {:blue, :pawn}},
      {{:b, 7}, {:blue, :pawn}},
      {{:c, 7}, :mt},
      {{:d, 7}, {:blue, :pawn}},
      {{:e, 7}, :mt},
      {{:f, 7}, {:orange, :bishop}},
      {{:g, 7}, {:blue, :pawn}},
      {{:h, 7}, {:blue, :pawn}},
      {{:a, 6}, {:orange, :pawn}},
      {{:b, 6}, :mt},
      {{:c, 6}, {:orange, :pawn}},
      {{:d, 6}, {:orange, :pawn}},
      {{:e, 6}, :mt},
      {{:f, 6}, {:blue, :king}},
      {{:g, 6}, :mt},
      {{:h, 6}, :mt},
      {{:a, 5}, :mt},
      {{:b, 5}, {:orange, :pawn}},
      {{:c, 5}, :mt},
      {{:d, 5}, :mt},
      {{:e, 5}, {:orange, :knight}},
      {{:f, 5}, :mt},
      {{:g, 5}, :mt},
      {{:h, 5}, :mt},
      {{:a, 4}, :mt},
      {{:b, 4}, :mt},
      {{:c, 4}, :mt},
      {{:d, 4}, {:orange, :rook}},
      {{:e, 4}, {:orange, :pawn}},
      {{:f, 4}, {:orange, :pawn}},
      {{:g, 4}, {:orange, :pawn}},
      {{:h, 4}, :mt},
      {{:a, 3}, :mt},
      {{:b, 3}, :mt},
      {{:c, 3}, :mt},
      {{:d, 3}, :mt},
      {{:e, 3}, :mt},
      {{:f, 3}, :mt},
      {{:g, 3}, :mt},
      {{:h, 3}, :mt},
      {{:a, 2}, :mt},
      {{:b, 2}, :mt},
      {{:c, 2}, :mt},
      {{:d, 2}, :mt},
      {{:e, 2}, :mt},
      {{:f, 2}, :mt},
      {{:g, 2}, :mt},
      {{:h, 2}, {:orange, :pawn}},
      {{:a, 1}, :mt},
      {{:b, 1}, :mt},
      {{:c, 1}, :mt},
      {{:d, 1}, :mt},
      {{:e, 1}, {:orange, :king}},
      {{:f, 1}, {:orange, :rook}},
      {{:g, 1}, :mt},
      {{:h, 1}, :mt}
    ]

    checkmate_fetched_locs = Chessboard.fetch_locations(parsed_checkmated.placements)
    assert checkmate_fetched_locs == parsed_checkmate_locs


    filtered_for_color = [{{:g, 8}, {:orange, :knight}}, {{:f, 7}, {:orange, :bishop}}, {{:a, 6}, {:orange, :pawn}}, {{:c, 6}, {:orange, :pawn}}, {{:d, 6}, {:orange, :pawn}}, {{:b, 5}, {:orange, :pawn}}, {{:e, 5}, {:orange, :knight}}, {{:d, 4}, {:orange, :rook}}, {{:e, 4}, {:orange, :pawn}}, {{:f, 4}, {:orange, :pawn}}, {{:g, 4}, {:orange, :pawn}}, {{:h, 2}, {:orange, :pawn}}, {{:e, 1}, {:orange, :king}}, {{:f, 1}, {:orange, :rook}}]

    assert checkmate_fetched_locs
    |> filter_location_placement_tuples_for_color(:orange) == filtered_for_color

    possible_moves_checkmated = [[{{:g, 8}, {:e, 7}}, {{:g, 8}, {:f, 6}}, {{:g, 8}, {:h, 6}}], [{{:f, 7}, {:e, 8}}, {{:f, 7}, {:e, 6}}, {{:f, 7}, {:d, 5}}, {{:f, 7}, {:c, 4}}, {{:f, 7}, {:b, 3}}, {{:f, 7}, {:a, 2}}, {{:f, 7}, {:g, 6}}, {{:f, 7}, {:h, 5}}], [{{:a, 6}, {:b, 7}}], [{{:c, 6}, {:c, 7}}, {{:c, 6}, {:b, 7}}, {{:c, 6}, {:d, 7}}], [], [{{:b, 5}, {:b, 6}}], [{{:e, 5}, {:d, 7}}, {{:e, 5}, {:g, 6}}, {{:e, 5}, {:c, 4}}, {{:e, 5}, {:d, 3}}, {{:e, 5}, {:f, 3}}], [{{:d, 4}, {:d, 5}}, {{:d, 4}, {:d, 3}}, {{:d, 4}, {:d, 2}}, {{:d, 4}, {:d, 1}}, {{:d, 4}, {:c, 4}}, {{:d, 4}, {:b, 4}}, {{:d, 4}, {:a, 4}}], [], [{{:f, 4}, {:f, 5}}], [{{:g, 4}, {:g, 5}}], [{{:h, 2}, {:h, 4}}, {{:h, 2}, {:h, 3}}], [{{:e, 1}, {:e, 2}}, {{:e, 1}, {:d, 1}}, {{:e, 1}, {:d, 2}}, {{:e, 1}, {:f, 2}}], [{{:f, 1}, {:f, 2}}, {{:f, 1}, {:f, 3}}, {{:f, 1}, {:g, 1}}, {{:f, 1}, {:h, 1}}]]
    assert checkmate_fetched_locs
    |> filter_location_placement_tuples_for_color(:orange)
    |> grab_possible_moves(parsed_checkmated) == possible_moves_checkmated

    assert [[{{:g, 8}, {:e, 7}}]] |> infer_move_type_from_board(parsed_checkmated)
    reordered_checkmated = [{:jumping, {:g, 8}, {:e, 7}}, {:jumping, {:g, 8}, {:f, 6}}, {:jumping, {:g, 8}, {:h, 6}}, {:not_jumping, {:f, 7}, {:e, 8}}, {:not_jumping, {:f, 7}, {:e, 6}}, {:not_jumping, {:f, 7}, {:d, 5}}, {:not_jumping, {:f, 7}, {:c, 4}}, {:not_jumping, {:f, 7}, {:b, 3}}, {:not_jumping, {:f, 7}, {:a, 2}}, {:not_jumping, {:f, 7}, {:g, 6}}, {:not_jumping, {:f, 7}, {:h, 5}}, {:not_jumping, {:a, 6}, {:b, 7}}, {:not_jumping, {:c, 6}, {:c, 7}}, {:not_jumping, {:c, 6}, {:b, 7}}, {:not_jumping, {:c, 6}, {:d, 7}}, {:not_jumping, {:b, 5}, {:b, 6}}, {:jumping, {:e, 5}, {:d, 7}}, {:jumping, {:e, 5}, {:g, 6}}, {:jumping, {:e, 5}, {:c, 4}}, {:jumping, {:e, 5}, {:d, 3}}, {:jumping, {:e, 5}, {:f, 3}}, {:not_jumping, {:d, 4}, {:d, 5}}, {:not_jumping, {:d, 4}, {:d, 3}}, {:not_jumping, {:d, 4}, {:d, 2}}, {:not_jumping, {:d, 4}, {:d, 1}}, {:not_jumping, {:d, 4}, {:c, 4}}, {:not_jumping, {:d, 4}, {:b, 4}}, {:not_jumping, {:d, 4}, {:a, 4}}, {:not_jumping, {:f, 4}, {:f, 5}}, {:not_jumping, {:g, 4}, {:g, 5}}, {:not_jumping, {:h, 2}, {:h, 4}}, {:not_jumping, {:h, 2}, {:h, 3}}, {:not_jumping, {:e, 1}, {:e, 2}}, {:not_jumping, {:e, 1}, {:d, 1}}, {:not_jumping, {:e, 1}, {:d, 2}}, {:not_jumping, {:e, 1}, {:f, 2}}, {:not_jumping, {:f, 1}, {:f, 2}}, {:not_jumping, {:f, 1}, {:f, 3}}, {:not_jumping, {:f, 1}, {:g, 1}}, {:not_jumping, {:f, 1}, {:h, 1}}]
    assert checkmate_fetched_locs
    |> filter_location_placement_tuples_for_color(:orange)
    |> grab_possible_moves(parsed_checkmated)
    |> infer_move_type_from_board(parsed_checkmated) == reordered_checkmated
    # |> throw_out_ob_and_remove_promote_type_and_filter_out_blocked(placements)
    # |> remove_move_onlies()
    # |> thruple_to_tuple_kill_movetype()


    c_threatening_moves = threatens(parsed_checkmated, :orange)
    assert c_threatening_moves == [
      {{:g, 8}, {:e, 7}},
      {{:g, 8}, {:f, 6}},
      {{:g, 8}, {:h, 6}},
      {{:f, 7}, {:e, 8}},
      {{:f, 7}, {:e, 6}},
      {{:f, 7}, {:d, 5}},
      {{:f, 7}, {:c, 4}},
      {{:f, 7}, {:b, 3}},
      {{:f, 7}, {:a, 2}},
      {{:f, 7}, {:g, 6}},
      {{:f, 7}, {:h, 5}},
      {{:a, 6}, {:b, 7}},
      {{:c, 6}, {:c, 7}},
      {{:c, 6}, {:b, 7}},
      {{:c, 6}, {:d, 7}},
      {{:b, 5}, {:b, 6}},
      {{:e, 5}, {:d, 7}},
      {{:e, 5}, {:g, 6}},
      {{:e, 5}, {:c, 4}},
      {{:e, 5}, {:d, 3}},
      {{:e, 5}, {:f, 3}},
      {{:d, 4}, {:d, 5}},
      {{:d, 4}, {:d, 3}},
      {{:d, 4}, {:d, 2}},
      {{:d, 4}, {:d, 1}},
      {{:d, 4}, {:c, 4}},
      {{:d, 4}, {:b, 4}},
      {{:d, 4}, {:a, 4}},
      {{:f, 4}, {:f, 5}},
      {{:g, 4}, {:g, 5}},
      {{:h, 2}, {:h, 4}},
      {{:h, 2}, {:h, 3}},
      {{:e, 1}, {:e, 2}},
      {{:e, 1}, {:d, 1}},
      {{:e, 1}, {:d, 2}},
      {{:e, 1}, {:f, 2}},
      {{:f, 1}, {:f, 2}},
      {{:f, 1}, {:f, 3}},
      {{:f, 1}, {:g, 1}},
      {{:f, 1}, {:h, 1}}
    ]


    c_threatened = c_threatening_moves |> Enum.map(&move_to_end_loc/1)
    assert c_threatened == [
      {:e, 7},
      {:f, 6},
      {:h, 6},
      {:e, 8},
      {:e, 6},
      {:d, 5},
      {:c, 4},
      {:b, 3},
      {:a, 2},
      {:g, 6},
      {:h, 5},
      {:b, 7},
      {:c, 7},
      {:b, 7},
      {:d, 7},
      {:b, 6},
      {:d, 7},
      {:g, 6},
      {:c, 4},
      {:d, 3},
      {:f, 3},
      {:d, 5},
      {:d, 3},
      {:d, 2},
      {:d, 1},
      {:c, 4},
      {:b, 4},
      {:a, 4},
      {:f, 5},
      {:g, 5},
      {:h, 4},
      {:h, 3},
      {:e, 2},
      {:d, 1},
      {:d, 2},
      {:f, 2},
      {:f, 2},
      {:f, 3},
      {:g, 1},
      {:h, 1}
    ]
    c_king_loc = findKing(parsed_checkmated.placements, :blue)
    assert c_king_loc == {:f, 6}

    assert Enum.member?(c_threatened, c_king_loc) == true

    assert isCheck(parsed_checkmated, :blue) == true


    assert isCheckmate(parsed_checkmated, :blue) == true
    assert checkmated_moved == parsed_checkmated

  end
end
  describe "debugging worktest" do
    test "debug kingThreatened, pawn taking a pawn puts king in check (because pawn is not visible to uncovered king)" do
      b_unscanned = %Chessboard{
        placements: [
          [
            blue: :rook,
            blue: :knight,
            blue: :bishop,
            blue: :queen,
            blue: :king,
            blue: :bishop,
            blue: :knight,
            blue: :rook
          ],
          [
            {:blue, :pawn},
            {:blue, :pawn},
            {:blue, :pawn},
            :mt,
            {:blue, :pawn},
            {:blue, :pawn},
            {:blue, :pawn},
            {:blue, :pawn}
          ],
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [:mt, :mt, :mt, {:orange, :pawn}, :mt, :mt, :mt, :mt],
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [
            {:orange, :pawn},
            {:orange, :pawn},
            {:orange, :pawn},
            {:orange, :pawn},
            :mt,
            {:orange, :pawn},
            {:orange, :pawn},
            {:orange, :pawn}
          ],
          [
            orange: :rook,
            orange: :knight,
            orange: :bishop,
            orange: :queen,
            orange: :king,
            orange: :bishop,
            orange: :knight,
            orange: :rook
          ]
        ],
        order: [:orange, :blue],
        impale_square: :no_impale,
        first_castleable: :both,
        second_castleable: :both,
        halfmove_clock: 0,
        fullmove_number: 2
      }

      b1 = Chessboard.createBoard()
      |> move({:e, 2}, {:e, 4}, :orange, :pawn)
      |> split_tuple()
      |> move({:d, 7}, {:d, 5}, :blue, :pawn)
      |> split_tuple()

      king_loc = Chessboard.findKing(b1.placements, :orange)
      assert king_loc == {:e, 1}
      #View.CLI.showGameBoardAs(b1, :orange)

      #View.CLI.showGameBoardAs(b_unscanned, :orange)

      location = {:e, 1}
      color = :orange
      placements = b_unscanned.placements
      assert peer_one_in_every_direction(location, color, placements)

      assert attackers_of(b1, king_loc) == [{{:d, 2}, {:orange, :pawn}}, {{:f, 2}, {:orange, :pawn}}, {{:d, 1}, {:orange, :queen}}]

      assert attackers_of(b_unscanned, king_loc) == [{{:d, 2}, {:orange, :pawn}}, {{:f, 2}, {:orange, :pawn}}, {{:d, 1}, {:orange, :queen}}]

    end
    test "debugging kingImmobileTest, bishops are blocking wrongly" do
      placement = [
      [
        {:blue, :rook},
        :mt,
        {:blue, :bishop},
        {:blue, :queen},
        {:blue, :king},
        {:blue, :bishop},
        :mt,
        {:blue, :rook}
      ],
      [
        {:blue, :pawn},
        {:blue, :pawn},
        {:blue, :pawn},
        {:blue, :pawn},
        :mt,
        {:blue, :pawn},
        {:blue, :pawn},
        {:blue, :pawn}
      ],
      [:mt, :mt, {:blue, :knight}, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, {:orange, :pawn}, :mt, :mt, :mt],
      [:mt, :mt, {:orange, :pawn}, :mt, :mt, :mt, {:blue, :knight}, :mt],
      [:mt, :mt, :mt, :mt, :mt, {:orange, :knight}, :mt, :mt],
      [
        {:orange, :pawn},
        {:orange, :pawn},
        :mt,
        :mt,
        {:orange, :pawn},
        {:orange, :pawn},
        {:orange, :pawn},
        {:orange, :pawn}
      ],
      [
        {:orange, :rook},
        {:orange, :knight},
        {:orange, :bishop},
        {:orange, :queen},
        {:orange, :king},
        {:orange, :bishop},
        :mt,
        {:orange, :rook}
      ]
    ]

    assert blocked(placement, {:c, 1}, {:d, 2}) == false
    assert blocked(placement, {:d, 2}, {:c, 1}) == false

    assert blocked(placement, {:c, 1}, {:e, 3}) == false
    assert blocked(placement, {:e, 3}, {:c, 1}) == false
    assert blocked(placement, {:f, 4}, {:c, 1}) == false
    end

    test "debugging blocked rook on open rank" do
      placements = [
        [
          :mt,
          {:blue, :knight},
          {:blue, :bishop},
          {:blue, :queen},
          {:blue, :king},
          {:blue, :bishop},
          {:blue, :knight},
          {:blue, :rook}
        ],
        [
          :mt,
          {:blue, :pawn},
          {:blue, :pawn},
          {:blue, :pawn},
          {:blue, :pawn},
          {:blue, :pawn},
          {:blue, :pawn},
          :mt
        ],
        [{:blue, :rook}, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [{:orange, :queen}, :mt, :mt, :mt, :mt, :mt, :mt, {:blue, :pawn}],
        [:mt, :mt, {:orange, :pawn}, :mt, :mt, :mt, :mt, {:orange, :pawn}],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [
          {:orange, :pawn},
          {:orange, :pawn},
          :mt,
          {:orange, :pawn},
          {:orange, :pawn},
          {:orange, :pawn},
          {:orange, :pawn},
          :mt
        ],
        [
          {:orange, :rook},
          {:orange, :knight},
          {:orange, :bishop},
          :mt,
          {:orange, :king},
          {:orange, :bishop},
          {:orange, :knight},
          {:orange, :rook}
        ]
      ]
      assert blocked(placements, {:a, 6}, {:h, 6}) == false
    end

    test "fix rando clause error" do

      # ◼ ◻ ♕ ◻ ♔ ♗ ◼ ♖
      # ♟︎ ♖ ♙ ♗ ♙ ♙ ♙ ♙
      # ◼ ◻ ♟︎ ◻ ◼ ◻ ♟︎ ♘
      # ◻ ◼ ◻ ◼ ◻ ♟︎ ◻ ◼
      # ♟︎ ♜ ♝ ♚ ◼ ◻ ◼ ◻
      # ◻ ◼ ◻ ◼ ♟︎ ◼ ♞ ♛
      # ◼ ◻ ◼ ♝ ◼ ◻ ◼ ♟︎
      # ◻ ◼ ◻ ♜ ◻ ◼ ◻ ◼

      # ◼ ◻ ◼ ♕ ♔ ♗ ◼ ♖
      # ♟︎ ♖ ♙ ♗ ♙ ♙ ♙ ♙
      # ◼ ◻ ♟︎ ◻ ◼ ◻ ♟︎ ♘
      # ◻ ◼ ◻ ◼ ◻ ♟︎ ◻ ◼
      # ♟︎ ♜ ♝ ♚ ◼ ◻ ◼ ◻
      # ◻ ◼ ◻ ◼ ♟︎ ◼ ♞ ♛
      # ◼ ◻ ◼ ♝ ◼ ◻ ◼ ♟︎
      # ◻ ◼ ◻ ♜ ◻ ◼ ◻ ◼

      # ◼ ◻ ◼ ♕ ♔ ♗ ◼ ♖
      # ♟︎ ♖ ♙ ♗ ♙ ♝ ♙ ♙
      # ◼ ◻ ♟︎ ◻ ◼ ◻ ♟︎ ♘
      # ◻ ◼ ◻ ◼ ◻ ♟︎ ◻ ◼
      # ♟︎ ♜ ◼ ♚ ◼ ◻ ◼ ◻
      # ◻ ◼ ◻ ◼ ♟︎ ◼ ♞ ♛
      # ◼ ◻ ◼ ♝ ◼ ◻ ◼ ♟︎
      # ◻ ◼ ◻ ♜ ◻ ◼ ◻ ◼

      # ** (FunctionClauseError) no function clause matching in anonymous fn/1 in Chessboard.noMovesResolvingCheck/2

      #     The following arguments were given to anonymous fn/1 in Chessboard.noMovesResolvingCheck/2:

      #         # 1
      #         [{{:h, 6}, {:f, 7}}]

      #     (board_model 0.1.0) lib/board.ex:1390: anonymous fn/1 in Chessboard.noMovesResolvingCheck/2
      #     (elixir 1.14.4) lib/enum.ex:1658: Enum."-map/2-lists^map/1-0-"/2
      #     (elixir 1.14.4) lib/enum.ex:1658: Enum."-map/2-lists^map/1-0-"/2
      #     (board_model 0.1.0) lib/board.ex:1390: Chessboard.noMovesResolvingCheck/2
      #     (board_model 0.1.0) lib/board.ex:1285: Chessboard.isOver/2
      #     (controller 0.1.0) lib/game.ex:231: GameRunner.takeTurns/1
      #     (controller 0.1.0) lib/game.ex:104: GameRunner.runGame/2
      # iex(8)>



# ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
# ◻ ◼ ◻ ◼ ◻ ◼ ♜ ◼
# ◼ ♟︎ ◼ ♟︎ ♔ ◻ ◼ ♖
# ◻ ◼ ♙ ◼ ◻ ◼ ◻ ◼
# ◼ ◻ ◼ ♛ ◼ ◻ ◼ ◻
# ◻ ◼ ◻ ◼ ◻ ◼ ♜ ◼
# ◼ ◻ ♝ ◻ ◼ ◻ ◼ ♝
# ◻ ◼ ◻ ◼ ◻ ◼ ♚ ♞

# ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
# ◻ ◼ ◻ ◼ ◻ ◼ ♜ ◼
# ◼ ♟︎ ◼ ♟︎ ♔ ◻ ♜ ♖
# ◻ ◼ ♙ ◼ ◻ ◼ ◻ ◼
# ◼ ◻ ◼ ♛ ◼ ◻ ◼ ◻
# ◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
# ◼ ◻ ♝ ◻ ◼ ◻ ◼ ♝
# ◻ ◼ ◻ ◼ ◻ ◼ ♚ ♞

# ** (FunctionClauseError) no function clause matching in anonymous fn/1 in Chessboard.noMovesResolvingCheck/2

#     The following arguments were given to anonymous fn/1 in Chessboard.noMovesResolvingCheck/2:

#         # 1
#         [{{:h, 6}, {:g, 6}}]

#     (board_model 0.1.0) lib/board.ex:1389: anonymous fn/1 in Chessboard.noMovesResolvingCheck/2
#     (elixir 1.14.4) lib/enum.ex:1658: Enum."-map/2-lists^map/1-0-"/2
#     (elixir 1.14.4) lib/enum.ex:1658: Enum."-map/2-lists^map/1-0-"/2
#     (board_model 0.1.0) lib/board.ex:1389: Chessboard.noMovesResolvingCheck/2
#     (board_model 0.1.0) lib/board.ex:1284: Chessboard.isOver/2
#     (controller 0.1.0) lib/game.ex:231: GameRunner.takeTurns/1
#     (controller 0.1.0) lib/game.ex:104: GameRunner.runGame/2
# iex(2)>


# ◼ ◻ ◼ ◻ ◼ ◻ ♔ ◻
# ♙ ◼ ♙ ♗ ♛ ♙ ♖ ♙
# ♟︎ ◻ ♟︎ ♞ ◼ ◻ ♟︎ ♘
# ◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
# ◼ ◻ ◼ ◻ ◼ ◻ ◼ ♜
# ◻ ♟︎ ♟︎ ◼ ♟︎ ◼ ◻ ◼
# ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
# ◻ ◼ ♚ ◼ ♞ ◼ ◻ ◼

# ◼ ◻ ◼ ♛ ◼ ◻ ♔ ◻
# ♙ ◼ ♙ ♗ ◻ ♙ ♖ ♙
# ♟︎ ◻ ♟︎ ♞ ◼ ◻ ♟︎ ♘
# ◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼
# ◼ ◻ ◼ ◻ ◼ ◻ ◼ ♜
# ◻ ♟︎ ♟︎ ◼ ♟︎ ◼ ◻ ◼
# ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
# ◻ ◼ ♚ ◼ ♞ ◼ ◻ ◼

# ** (FunctionClauseError) no function clause matching in anonymous fn/1 in Chessboard.noMovesResolvingCheck/2

#     The following arguments were given to anonymous fn/1 in Chessboard.noMovesResolvingCheck/2:

#         # 1
#         [{{:d, 7}, {:e, 8}}]

#     (board_model 0.1.0) lib/board.ex:1389: anonymous fn/1 in Chessboard.noMovesResolvingCheck/2
#     (elixir 1.14.4) lib/enum.ex:1658: Enum."-map/2-lists^map/1-0-"/2
#     (elixir 1.14.4) lib/enum.ex:1658: Enum."-map/2-lists^map/1-0-"/2
#     (board_model 0.1.0) lib/board.ex:1389: Chessboard.noMovesResolvingCheck/2
#     (board_model 0.1.0) lib/board.ex:1284: Chessboard.isOver/2
#     (controller 0.1.0) lib/game.ex:231: GameRunner.takeTurns/1
#     (controller 0.1.0) lib/game.ex:104: GameRunner.runGame/2
# iex(5)>

# ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
# ◻ ♟︎ ♟︎ ♟︎ ◻ ◼ ♕ ♙
# ◼ ◻ ♟︎ ◻ ◼ ◻ ◼ ♟︎
# ♙ ◼ ◻ ◼ ◻ ♝ ◻ ♟︎
# ◼ ◻ ◼ ◻ ◼ ◻ ◼ ♛
# ◻ ◼ ◻ ◼ ◻ ♔ ◻ ◼
# ◼ ◻ ◼ ◻ ♜ ◻ ◼ ◻
# ◻ ◼ ◻ ◼ ◻ ♚ ◻ ♞

# ◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻
# ◻ ♟︎ ♟︎ ♟︎ ◻ ◼ ♕ ♙
# ◼ ◻ ♟︎ ◻ ◼ ◻ ◼ ♟︎
# ♙ ◼ ◻ ◼ ◻ ♝ ◻ ♟︎
# ◼ ◻ ◼ ◻ ◼ ◻ ♛ ◻
# ◻ ◼ ◻ ◼ ◻ ♔ ◻ ◼
# ◼ ◻ ◼ ◻ ♜ ◻ ◼ ◻
# ◻ ◼ ◻ ◼ ◻ ♚ ◻ ♞

# %Outcome{
#   players: [
#     %Player{type: :computer, color: :orange, tag: "_opponent_", lvl: 1},
#     %Player{type: :computer, color: :blue, tag: "_player_", lvl: 0}
#   ],
#   resolution: :drawn,
#   reason: :agreed,
#   games: [],
#   score: [0, 0]
# }
# iex(8)>


# ◼ ♖ ♗ ♕ ♔ ♗ ♘ ♖
# ♙ ♙ ◻ ♙ ♙ ♙ ♙ ♙
# ◼ ◻ ♟︎ ♙ ◼ ♟︎ ♟︎ ◻
# ◻ ♟︎ ◻ ◼ ◻ ◼ ◻ ◼
# ♟︎ ♛ ◼ ◻ ♟︎ ◻ ◼ ♟︎
# ◻ ◼ ♝ ◼ ◻ ◼ ◻ ◼
# ♝ ◻ ♟︎ ◻ ◼ ♜ ◼ ◻
# ◻ ♞ ◻ ◼ ♜ ♚ ◻ ◼

# ◼ ♖ ♗ ♕ ♔ ♗ ♘ ♖
# ♙ ♙ ◻ ♙ ♙ ♝ ♙ ♙
# ◼ ◻ ♟︎ ♙ ◼ ♟︎ ♟︎ ◻
# ◻ ♟︎ ◻ ◼ ◻ ◼ ◻ ◼
# ♟︎ ♛ ◼ ◻ ♟︎ ◻ ◼ ♟︎
# ◻ ◼ ♝ ◼ ◻ ◼ ◻ ◼
# ◼ ◻ ♟︎ ◻ ◼ ♜ ◼ ◻
# ◻ ♞ ◻ ◼ ♜ ♚ ◻ ◼

# %Outcome{
#   players: [
#     %Player{type: :computer, color: :orange, tag: "_player_", lvl: 1},
#     %Player{type: :computer, color: :blue, tag: "_opponent_", lvl: 0}
#   ],
#   resolution: :drawn,
#   reason: :agreed,
#   games: [],
#   score: [0, 0]
# }
# iex(14)>

      before_placements_str =
      """
      ◼ ♖ ♗ ♕ ♔ ♗ ♘ ♖
      ♙ ♙ ◻ ♙ ♙ ♙ ♙ ♙
      ◼ ◻ ♟︎ ♙ ◼ ♟︎ ♟︎ ◻
      ◻ ♟︎ ◻ ◼ ◻ ◼ ◻ ◼
      ♟︎ ♛ ◼ ◻ ♟︎ ◻ ◼ ♟︎
      ◻ ◼ ♝ ◼ ◻ ◼ ◻ ◼
      ♝ ◻ ♟︎ ◻ ◼ ♜ ◼ ◻
      ◻ ♞ ◻ ◼ ♜ ♚ ◻ ◼
      """
      before_placements = before_placements_str |> Parser.parseBoardFromString()
      assert before_placements == [
        [:mt, {:blue, :rook}, {:blue, :bishop}, {:blue, :queen}, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
        [{:blue, :pawn}, {:blue, :pawn}, :mt, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}],
        [:mt, :mt, {:orange, :pawn}, {:blue, :pawn}, :mt, {:orange, :pawn}, {:orange, :pawn}, :mt],
        [:mt, {:orange, :pawn}, :mt, :mt, :mt, :mt, :mt, :mt],
        [{:orange, :pawn}, {:orange, :queen}, :mt, :mt, {:orange, :pawn}, :mt, :mt, {:orange, :pawn}],
        [:mt, :mt, {:orange, :bishop}, :mt, :mt, :mt, :mt, :mt],
        [{:orange, :bishop}, :mt, {:orange, :pawn}, :mt, :mt, {:orange, :rook}, :mt, :mt],
        [:mt, {:orange, :knight}, :mt, :mt, {:orange, :rook}, {:orange, :king}, :mt, :mt]
      ]
      before = %Chessboard{placements: before_placements}
      assert isCheckmate(before, :blue) == false
      assert isStalemate(before, :blue) == false

    after_placements_str =
      """
      ◼ ♖ ♗ ♕ ♔ ♗ ♘ ♖
      ♙ ♙ ◻ ♙ ♙ ♝ ♙ ♙
      ◼ ◻ ♟︎ ♙ ◼ ♟︎ ♟︎ ◻
      ◻ ♟︎ ◻ ◼ ◻ ◼ ◻ ◼
      ♟︎ ♛ ◼ ◻ ♟︎ ◻ ◼ ♟︎
      ◻ ◼ ♝ ◼ ◻ ◼ ◻ ◼
      ◼ ◻ ♟︎ ◻ ◼ ♜ ◼ ◻
      ◻ ♞ ◻ ◼ ♜ ♚ ◻ ◼
      """
    after_placements = after_placements_str |> Parser.parseBoardFromString()
    assert after_placements == [
      [:mt, {:blue, :rook}, {:blue, :bishop}, {:blue, :queen}, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
      [{:blue, :pawn}, {:blue, :pawn}, :mt, {:blue, :pawn}, {:blue, :pawn}, {:orange, :bishop}, {:blue, :pawn}, {:blue, :pawn}],
      [:mt, :mt, {:orange, :pawn}, {:blue, :pawn}, :mt, {:orange, :pawn}, {:orange, :pawn}, :mt],
      [:mt, {:orange, :pawn}, :mt, :mt, :mt, :mt, :mt, :mt],
      [{:orange, :pawn}, {:orange, :queen}, :mt, :mt, {:orange, :pawn}, :mt, :mt, {:orange, :pawn}],
      [:mt, :mt, {:orange, :bishop}, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, {:orange, :pawn}, :mt, :mt, {:orange, :rook}, :mt, :mt],
      [:mt, {:orange, :knight}, :mt, :mt, {:orange, :rook}, {:orange, :king}, :mt, :mt]
    ]
    after_b = %Chessboard{placements: after_placements}
    assert isCheckmate(after_b, :blue) == true
    assert isStalemate(after_b, :blue) == false
    assert isOver(after_b, :blue) == true
    assert isOver(after_b, :orange) == false

    end

  end

  describe "kingImmobile" do
    test "them doctests" do
      b = Chessboard.createBoard()
      p = b.placements
      blocked = MoveCollection.kingBlockedByOwnPieces()
      stale = MoveCollection.shorteststalemate()
      assert Chessboard.kingImmobile(b, :orange) == true
      #View.CLI.showPlacementsAs(blocked.placements, :orange)
      #IO.puts("")
      assert Chessboard.kingImmobile(blocked, :orange) == true
      #IO.puts("")
      #View.CLI.showPlacementsAs(blocked.placements, :orange)
      #IO.puts("")

      king_loc = {:e, 8}
      #View.CLI.showGameBoardAs(blocked, :blue)
      unappraised = Moves.unappraised_moves(:blue, :king, king_loc)
      assert unappraised == [
        {:forwardstep, {:e, 7}},
        {:sidestep, {:f, 8}},
        {:sidestep, {:d, 8}},
        {:duck, {:f, 7}},
        {:duck, {:d, 7}},
        {:shortcastle, {:g, 8}},
        {:longcastle, {:c, 8}}
      ]

      #View.CLI.showGameBoardAs(blocked, :blue)
      my_possible_king_moves_blue = possible_moves(blocked, {:e, 8}, :blue)
      my_possible_king_moves_orange = possible_moves(blocked, {:e, 1}, :orange)


      assert unappraised == [
        {:forwardstep, {:e, 7}},
        {:sidestep, {:f, 8}},
        {:sidestep, {:d, 8}},
        {:duck, {:f, 7}},
        {:duck, {:d, 7}},
        {:shortcastle, {:g, 8}},
        {:longcastle, {:c, 8}}
      ]

      assert my_possible_king_moves_orange == []
      assert Moves.unappraised_moves(:blue, :king, {:e, 8}) == [forwardstep: {:e, 7}, sidestep: {:f, 8}, sidestep: {:d, 8}, duck: {:f, 7}, duck: {:d, 7}, shortcastle: {:g, 8}, longcastle: {:c, 8}]
      assert Location.nextTo(:e, :f) == true
      assert Location.nextTo(8, 8) == false
      assert Moves.retrieveMoveType({:e, 8}, {:d, 8}, :king, :blue) == :majestep
      assert Moves.retrieveMoveType({:e, 8}, {:f, 8}, :king, :blue) == :majestep

      {res, _msg} = move(blocked, {:e, 8}, {:d, 8}, :blue, :king, :nopromote)
      assert res == :ok
      {res2, _msg2} = move(blocked, {:e, 8}, {:f, 8}, :blue, :king, :nopromote)
      assert res2 == :ok
      assert my_possible_king_moves_blue == [{{:e, 8}, {:f, 8}}, {{:e, 8}, {:d, 8}}, {{:e, 8}, {:g, 8}}]
      assert Chessboard.kingImmobile(blocked, :blue) == false
      assert Chessboard.kingImmobile(blocked, :orange) == true

      #View.CLI.showPlacementsAs(stale.placements, :blue)
      #IO.puts("")

      tuple = move(stale, {:g, 6}, {:e, 6}, :blue, :king)
      assert tuple == {:error, "invalid movetype"}

      {res, _brd} = appraise_move(stale, {:g, 6}, {:e, 6}, {:blue, :king})

      #View.CLI.showGameBoardAs(brd, :orange)
      assert res == :error

      assert findKing(stale.placements, :blue) == {:g, 6}
      assert possible_moves(stale, {:g, 6}, :blue) == []
      assert Chessboard.kingImmobile(stale, :blue) == true
      #View.CLI.showGameBoardAs(stale, :orange)
      assert findKing(stale.placements, :orange) == {:e, 1}
      assert Moves.unappraised_moves(:orange, :king, {:e, 1}) == [
        {:forwardstep, {:e, 2}},
        {:sidestep, {:d, 1}},
        {:sidestep, {:f, 1}},
        {:duck, {:d, 2}},
        {:duck, {:f, 2}},
        {:shortcastle, {:g, 1}},
        {:longcastle, {:c, 1}}
      ]
      {res, _msg} = appraise_move(stale, {:a, 2}, {:a, 4}, {:orange, :pawn})
      assert res == :ok
      assert Moves.retrieveMoveType({:e, 1}, {:d, 1}, :king, :orange) == :majestep
      {res3, _msg3} = move(stale, {:e, 1}, {:d, 1}, :orange, :king)
      assert res3 == :ok

      {res2, _msg2} = appraise_move(stale, {:e, 1}, {:d, 1}, {:orange, :king})
      assert res2 == :ok
      assert possible_moves(stale, {:e, 1}, :orange) == [{{:e, 1}, {:d, 1}}]
      assert Chessboard.kingImmobile(stale, :orange) == false
      assert Chessboard.kingImmobile(stale, :blue) == true
      assert Chessboard.kingImmobile(stale, :orange) == false
      assert_raise FunctionClauseError, fn ->
        Chessboard.kingImmobile(p, :orange)
      end
    end
  end


  describe "Chessboard.make2DList(_,_)" do
    test "make 3x3 board" do
      assert make2DList(3, 3) == [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]
    end

    test "make 8 by 8 board" do
      assert make2DList(8, 8) == [
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
      assert make2DList(5, 5) == [
               [:mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt],
               [:mt, :mt, :mt, :mt, :mt]
             ]
    end

    test "make 3 by 4 and 4 by 3 boards" do
      assert make2DList(3, 4) == [
               [:mt, :mt, :mt],
               [:mt, :mt, :mt],
               [:mt, :mt, :mt],
               [:mt, :mt, :mt]
             ]

      assert make2DList(4, 3) == [[:mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt]]
    end

    test "make sure argument bounds works, raise arg errors if outside 3 by 3 and 8 by 8 inclusive to things like 3 by 8 and 8 by 3" do
      assert_raise BoardError, fn ->
        make2DList(2, 3)
      end

      assert_raise BoardError, fn ->
        make2DList(3, 2)
      end

      assert_raise BoardError, fn ->
        make2DList(9, 3)
      end

      assert_raise BoardError, fn ->
        make2DList(3, 9)
      end
    end

    test "make sure zero and one raise arg errors" do
      assert_raise BoardError, fn ->
        make2DList(0, 0)
      end

      assert_raise BoardError, fn ->
        make2DList(1, 1)
      end
    end
  end

  # end of describe make2DList tests

  describe "private rec2DList(cols, rows)" do
    test "make empty boards" do
      assert rec2DList(1, 0) == []
      assert rec2DList(0, 0) == []
      assert rec2DList(0, 1) == []
      assert rec2DList(0, 6) == []
    end

    test "make 1 by 1 board" do
      assert rec2DList(1, 1) == [[:mt]]
    end

    test "make 2 by 1 boards and 1 by 2" do
      assert rec2DList(1, 2) == [[:mt], [:mt]]
      assert rec2DList(2, 1) == [[:mt, :mt]]
    end

    test "make 1 by 8 and 8 by 1" do
      assert rec2DList(1, 8) == [[:mt], [:mt], [:mt], [:mt], [:mt], [:mt], [:mt], [:mt]]
      assert rec2DList(8, 1) == [[:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt]]
    end

    test "make 8 by 8" do
      assert rec2DList(8, 8) == [
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
      assert rec2DList(64, 1) == [
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

  # end of rec2DList(cols, rows) tests

  describe "Chessboard.placePiece(board, location, pieceColor, pieceType) tests" do
    #setup "initialize all the various boards" do
    #  a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]
    #end

    test "invalid board passed in raises error" do
      assert_raise FunctionClauseError, fn ->
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
               [{:blue, :rook}, :mt, :mt]
             ]
    end

    test "place king on bottom right square" do
      a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]

      assert placePiece(a3x3, {:c, 3}, :orange, :king) == [
               [:mt, :mt, {:orange, :king}],
               [:mt, :mt, :mt],
               [:mt, :mt, :mt]
             ]
    end

    test "place orange pawn on middle square" do
      a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]

      assert placePiece(a3x3, {:a, 2}, :orange, :pawn) == [
               [:mt, :mt, :mt],
               [{:orange, :pawn}, :mt, :mt],
               [:mt, :mt, :mt]
             ]
    end
    test "place orange pawn on bottom left square" do
      a3x3 = [[:mt, :mt, :mt], [:mt, :mt, :mt], [:mt, :mt, :mt]]

      assert_raise BoardError, fn ->
        placePiece(a3x3, {:a, 1}, :orange, :pawn) == [
               [:mt, :mt, :mt],
               [:mt, :mt, :mt],
               [{:orange, :pawn}, :mt, :mt]
             ]
            end
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
      [{:blue, :pawn}, :mt, :mt, :mt, :mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [{:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}],
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

      just_orange_pawns_placed = make2DList(8, 8)
      |> placePiece({:a, 2}, :orange, :pawn)
      |> placePiece({:b, 2}, :orange, :pawn)
      |> placePiece({:c, 2}, :orange, :pawn)
      |> placePiece({:d, 2}, :orange, :pawn)
      |> placePiece({:e, 2}, :orange, :pawn)
      |> placePiece({:f, 2}, :orange, :pawn)
      |> placePiece({:g, 2}, :orange, :pawn)
      |> placePiece({:h, 2}, :orange, :pawn)

      just_blue_pieces_placed = make2DList(8, 8)
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
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [{:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}],
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

  describe "Chessboard.inRankUpZone(di)" do
    test "basic 3x3 board has rank up zone orange at top (so row 3) and rank up zone blue at bottom (so row 1)" do
      assert inRankUpZone({3, 3}, {3, 1}, :orange) == false
      assert inRankUpZone({3, 3}, {3, 3}, :orange) == true
      assert inRankUpZone({3, 3}, {3, 1}, :blue) == true
      assert inRankUpZone({3, 3}, {3, 3}, :blue) == false
      assert inRankUpZone({3, 3}, {3, 2}, :blue) == false
      assert inRankUpZone({3, 3}, {3, 2}, :orange) == false
    end

    test "8x8 board has orange at top (rank 8), blue at bottom (rank/row 1)" do
      assert inRankUpZone({8, 8}, {6, 1}, :orange) == false
      assert inRankUpZone({7, 8}, {4, 8}, :orange) == true
      assert inRankUpZone({6, 8}, {5, 1}, :blue) == true
      assert inRankUpZone({5, 8}, {4, 8}, :blue) == false
      assert inRankUpZone({4, 8}, {3, 6}, :blue) == false
      assert inRankUpZone({3, 8}, {3, 2}, :orange) == false
    end
  end

  describe "Chessboard.boardSize(board) tests" do
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
  end

  describe "fLocationIsEmpty(board, location) tests" do
    test "impossible boards" do
      assert fLocationIsEmpty([[:mt]], {:a, 1}) == true
      assert fLocationIsEmpty([[:mt], [:mt]], {:a, 2}) == true
      assert fLocationIsEmpty([[:mt, :mt], [:mt, :mt]], {:b, 2}) == true
      assert fLocationIsEmpty([[:red, :mt], [:red, :mt]], {:b, 2}) == true
      assert fLocationIsEmpty([[:red, :red], [:red, :mt]], {:b, 2}) == false
      assert fLocationIsEmpty([[:red, :red], [:red, :mt]], {:b, 1}) == true
    end

    test "real boards" do
      a3x3 = make2DList(3, 3)
      #a8x8 = make2DList(8, 8)

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

  describe "Chessboard.placeTile" do
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

      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}, {:orange, {:h, 8}}], {:g, 4}) == false
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}, {:orange, {:h, 8}}], {:c, 4}) == true
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}, {:orange, {:h, 8}}], {:c, 1}) == true
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}, {:orange, {:h, 8}}], {:h, 8}) == true
      assert isReplacingTile([{:red, {:a, 1}}, {:green, {:c, 4}}, {:blue, {:c, 1}}, {:orange, {:h, 8}}], {:h, 7}) == false
    end
  end

  # end of placeTile tests

  describe "Chessboard.startingPosition" do
    test "basic starting position" do
      starting_board = [[{:blue, :rook}, {:blue, :knight}, {:blue, :bishop}, {:blue, :queen}, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
      [{:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
      [{:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}],
      [{:orange, :rook}, {:orange, :knight}, {:orange, :bishop}, {:orange, :queen}, {:orange, :king}, {:orange, :bishop}, {:orange, :knight}, {:orange, :rook}]]

      assert List.myers_difference(startingPosition(), starting_board) == [eq: starting_board]
      assert boardSize(startingPosition()) == {8, 8}
      assert boardSize(starting_board) == {8, 8}
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
      scotch = %Chessboard{placements: [
        [{:blue, :rook}, :mt, {:blue, :bishop}, {:blue, :queen}, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
        [{:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, :mt, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}],
        [:mt, :mt, {:blue, :knight}, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, {:blue, :pawn}, :mt, :mt, :mt],
        [:mt, :mt, :mt, {:orange, :pawn}, {:orange, :pawn}, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, {:orange, :knight}, :mt, :mt],
        [{:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, :mt, :mt, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}],
        [{:orange, :rook}, {:orange, :knight}, {:orange, :bishop}, {:orange, :queen}, {:orange, :king}, {:orange, :bishop}, :mt, {:orange, :rook}]
      ], fullmove_number: 3, impale_square: {:d, 3}}
      scotch_copy_pasted = %Chessboard{placements: [[{:blue, :rook}, :mt, {:blue, :bishop}, {:blue, :queen}, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}], [{:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, :mt, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}], [:mt, :mt, {:blue, :knight}, :mt, :mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt, {:blue, :pawn}, :mt, :mt, :mt], [:mt, :mt, :mt, {:orange, :pawn}, {:orange, :pawn}, :mt, :mt, :mt], [:mt, :mt, :mt, :mt, :mt, {:orange, :knight}, :mt, :mt], [{:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, :mt, :mt, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}], [{:orange, :rook}, {:orange, :knight}, {:orange, :bishop}, {:orange, :queen}, {:orange, :king}, {:orange, :bishop}, :mt, {:orange, :rook}]],
        order: [:orange, :blue], impale_square: {:d, 3}, first_castleable: :both, second_castleable: :both, halfmove_clock: 0, fullmove_number: 3}
      %Chessboard{placements: scotch}
      scotch_moved = Chessboard.createBoard()
      |> move({:e, 2}, {:e, 4}, :orange, :pawn) # or sprint
      |> split_tuple()
      |> move({:e, 7}, {:e, 5}, :blue, :pawn) # or :sprint
      |> split_tuple()
      |> move({:g, 1}, {:f, 3}, :orange, :knight) # or :leftvert
      |> split_tuple()
      |> move({:b, 8}, {:c, 6}, :blue, :knight)
      |> split_tuple()
      |> move({:d, 2}, {:d, 4}, :orange, :pawn)
      |> split_tuple()
      assert scotch == scotch_copy_pasted
      assert scotch == scotch_moved
      assert List.myers_difference(scotch.placements, scotch_moved.placements) == [eq: scotch.placements]
    end
  end

  # end of startingPosition tests

  @tag :move
  describe "Chessboard.move" do
    test "basic move, lets say e4 as orange" do
      b = Chessboard.createBoard()
      {res, msg} = Chessboard.move(b, {:d, 2}, {:d, 4}, :orange, :pawn, :nopromote)
      assert res == :ok
      assert msg == %Chessboard{placements: [[blue: :rook, blue: :knight, blue: :bishop, blue: :queen, blue: :king, blue: :bishop, blue: :knight, blue: :rook], [blue: :pawn, blue: :pawn, blue: :pawn, blue: :pawn, blue: :pawn, blue: :pawn, blue: :pawn, blue: :pawn], [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt], [:mt, :mt, :mt, {:orange, :pawn}, :mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt], [{:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, :mt, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}], [orange: :rook, orange: :knight, orange: :bishop, orange: :queen, orange: :king, orange: :bishop, orange: :knight, orange: :rook]], order: [:orange, :blue], impale_square: {:d, 3}, first_castleable: :both, second_castleable: :both, halfmove_clock: 0, fullmove_number: 1}

    end

    test "a series of moves passed into each other, lets say the scotch opening" do
    end

    test "a series of moves with a pawn capture" do
      b1 = Chessboard.createBoard()
      |> move({:e, 2}, {:e, 4}, :orange, :pawn)
      |> split_tuple()
      |> move({:d, 7}, {:d, 5}, :blue, :pawn)
      |> split_tuple()
      assert b1 |> is_struct()
      #
      #IO.inspect(b1)
      #View.CLI.showGameBoardAs(b1, :orange)

      b2 = b1
      |> move({:e, 4}, {:d, 5}, :orange, :pawn)
      assert {:ok, _b2r} = b2

    end

    test "a series of moves passed into each other, lets say the scandinavian opening where queen moves to a5" do

      scandinavian = %Chessboard{placements: [
        [{:blue, :rook}, {:blue, :knight}, {:blue, :bishop}, :mt, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
        [{:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, :mt, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [{:blue, :queen}, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
        [:mt, :mt, {:orange, :knight}, :mt, :mt, :mt, :mt, :mt],
        [{:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, :mt, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}],
        [{:orange, :rook}, :mt, {:orange, :bishop}, {:orange, :queen}, {:orange, :king}, {:orange, :bishop}, {:orange, :knight}, {:orange, :rook}]
      ], fullmove_number: 4, halfmove_clock: 2}
      scandinavian_copy_pasted = %Chessboard{
        first_castleable: :both,
        fullmove_number: 4,
        halfmove_clock: 2,
        impale_square: :noimpale,
        order: [:orange, :blue],
        placements: [
          [{:blue, :rook}, {:blue, :knight}, {:blue, :bishop}, :mt, {:blue, :king}, {:blue, :bishop}, {:blue, :knight}, {:blue, :rook}],
          [{:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, :mt, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}, {:blue, :pawn}],
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [{:blue, :queen}, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt],
          [:mt, :mt, {:orange, :knight}, :mt, :mt, :mt, :mt, :mt],
          [{:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}, :mt, {:orange, :pawn}, {:orange, :pawn}, {:orange, :pawn}],
          [{:orange, :rook}, :mt, {:orange, :bishop}, {:orange, :queen}, {:orange, :king}, {:orange, :bishop}, {:orange, :knight}, {:orange, :rook}]
        ],
        second_castleable: :both
      }

      scandinavian_moved = Chessboard.createBoard()
      |> move({:e, 2}, {:e, 4}, :orange, :pawn)
      |> split_tuple()
      |> move({:d, 7}, {:d, 5}, :blue, :pawn)
      |> split_tuple()
      |> move({:e, 4}, {:d, 5}, :orange, :pawn)
      |> split_tuple()
      |> move({:d, 8}, {:d, 5}, :blue, :queen)
      |> split_tuple()
      |> move({:b, 1}, {:c, 3}, :orange, :knight)
      |> split_tuple()
      |> move({:d, 5}, {:a, 5}, :blue, :queen)
      |> split_tuple()

      assert scandinavian == scandinavian_copy_pasted
      assert scandinavian == scandinavian_moved
      assert List.myers_difference(scandinavian.placements, scandinavian_moved.placements) == [eq: scandinavian.placements]
    end
  end

  # end of Chessboard.move tests

  describe "createBoardInitial" do
    test "basic initial create board" do
    end
  end

  # end of Chessboard.createBoardInitial

  describe "createBoard (intermediate)" do
    test "basic intermediate createBoard" do
    end
  end

  # end of Chessboard.createBoard

  describe "printBoard (board)" do
    test "startingposition" do
      assert printPlacements(startingPosition()) == "♖♘♗♕♔♗♘♖♙♙♙♙♙♙♙♙◼◻◼◻◼◻◼◻◻◼◻◼◻◼◻◼◼◻◼◻◼◻◼◻◻◼◻◼◻◼◻◼♟︎♟︎♟︎♟︎♟︎♟︎♟︎♟︎♜♞♝♛♚♝♞♜"
    end
  end


  describe "listPlacements (board)" do
    test "startingposition" do
      start = Chessboard.createBoard()
      assert listPlacements(start.placements) == [["♜", "♞", "♝", "♛", "♚", "♝", "♞", "♜"], ["♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎", "♟︎"], ["◻", "◻", "◻", "◻", "◻", "◻", "◻", "◻"], ["◻", "◻", "◻", "◻", "◻", "◻", "◻", "◻"], ["◻", "◻", "◻", "◻", "◻", "◻", "◻", "◻"], ["◻", "◻", "◻", "◻", "◻", "◻", "◻", "◻"], ["♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙"], ["♖", "♘", "♗", "♕", "♔", "♗", "♘", "♖"]]
    end
  end
end

# end of module
