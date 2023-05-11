defmodule ViewCLITest do
  @moduledoc """
  Testing the View.CLI
  """
  use ExUnit.Case
  import ExUnit.CaptureIO
  require View.CLI

  # doctest CLIView
  # excellent resource http://daisymolving.github.io/2016/09/10/testing-input-output.html
  # if contemplating mocking -> no
  # https://blog.appsignal.com/2023/04/11/an-introduction-to-mocking-tools-for-elixir.html

  test "showGameBoardAs (orange and blue)" do
    assert capture_io(fn ->
      View.CLI.showGameBoardAs(Board.createBoard(), :blue)
    end) == "♜ ♞ ♝ ♚ ♛ ♝ ♞ ♜\n♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎\n◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻\n◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼\n◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻\n◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼\n♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙\n♖ ♘ ♗ ♔ ♕ ♗ ♘ ♖\n\n"

    assert capture_io(fn ->
      View.CLI.showGameBoardAs(Board.createBoard(), :orange)
    end) == "♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖\n♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙\n◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻\n◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼\n◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻\n◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼\n♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎\n♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜\n\n"
  end

  test "displays :game_intro, with Bob, Georgina, and the default starting board" do
    bob = %Player{type: :human, color: :orange, tag: "Bob"}
    georgina = %Player{type: :cpu, color: :blue, tag: "Georgina"}
    assert capture_io(fn ->
      View.CLI.displays(:game_intro, bob, georgina, Board.createBoard())
    end) == "LET THE GAME BEGIN!!!\nFACING OFF TODAY:\nWE HAVE THE VENERABLE Bob OF TYPE human\nBATTLING AGAINST Georgina OF TYPE cpu.\n\nWHO SHALL BE THE VICTOR?\nTHE STARTING POSITION IS %Board{placements: [[blue: :rook, blue: :knight, blue: :bishop, blue: :queen, blue: :king, blue: :bishop, blue: :knight, blue: :rook], [blue: :pawn, blue: :pawn, blue: :pawn, blue: :pawn, blue: :pawn, blue: :pawn, blue: :pawn, blue: :pawn], [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt], [:mt, :mt, :mt, :mt, :mt, :mt, :mt, :mt], [orange: :pawn, orange: :pawn, orange: :pawn, orange: :pawn, orange: :pawn, orange: :pawn, orange: :pawn, orange: :pawn], [orange: :rook, orange: :knight, orange: :bishop, orange: :queen, orange: :king, orange: :bishop, orange: :knight, orange: :rook]], order: [:orange, :blue], impale_square: :noimpale, first_castleable: :both, second_castleable: :both, halfmove_clock: 0, fullmove_number: 1}:\n"
  end

  test "displays turn intro" do
    _bob = %Player{type: :human, color: :orange, tag: "Bob"}
    georgina = %Player{type: :cpu, color: :blue, tag: "Georgina"}

    assert capture_io(fn ->
      View.CLI.displays(:turn_intro, :red, georgina)
    end) == "The Turn is: :red, with player: #{inspect(georgina)}\n"

    assert capture_io(fn ->
      View.CLI.displays(:turn_intro, :blue, georgina)
    end) == "The Turn is: :blue, with player: #{inspect(georgina)}\n"

    assert capture_io(fn ->
      View.CLI.displays(:turn_intro, :orange)
    end) == "The Turn is: :orange\n"
  end

  test "displayGameBoard" do
    assert capture_io(fn ->
      View.CLI.displayGameBoard(Board.startingPosition() |> Board.printPlacements())
    end) == "♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖\n♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙\n◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻\n◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼\n◼ ◻ ◼ ◻ ◼ ◻ ◼ ◻\n◻ ◼ ◻ ◼ ◻ ◼ ◻ ◼\n♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎ ♟︎\n♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜\n\n"
    #"♜♞♝♛♚♝♞♜\n♟︎♟︎♟︎♟︎♟︎♟︎♟︎♟︎\n◻◼◻◼◻◼◻◼\n◼◻◼◻◼◻◼◻\n◻◼◻◼◻◼◻◼\n◼◻◼◻◼◻◼◻\n♙♙♙♙♙♙♙♙\n♖♘♗♕♔♗♘♖\n"
  end

  test "ask :game_turn" do
    assert capture_io("d4", fn ->
      output = View.CLI.ask(:game_turn)
      assert output == "D4"
    end) == "Enter a move:\n\n"

    assert capture_io([input: "d4", capture_prompt: false], fn ->
      p = View.CLI.ask(:game_turn)
      assert p == "D4"
    end) == "\n"

    {result, output} = with_io("d4", fn ->
      View.CLI.ask(:game_turn)
    end)
    assert result == "D4"
    assert output == "Enter a move:\n\n"
  end

  test "ask, retry" do
    assert View.CLI.retriable_ask(:game_turn, -1) == "resign"

    assert capture_io([input: "help", capture_prompt: false], fn ->
      View.CLI.retriable_ask(:game_turn, 0)
    end) == "\n"

    assert capture_io([input: "help", capture_prompt: false], fn ->
      o = View.CLI.retriable_ask(:game_turn, 1)
      assert o == "HELP"
    end) == "\n"

    {result, output} = with_io("d4", fn ->
      View.CLI.retriable_ask(:game_turn, 1)
    end)
    assert result == "D4"
    assert output == "Enter a move:\n\n"
  end

  @tag :skip
  test "startNewWindow (OS dependent)" do
    thing = case :os.type() do
      {:win32, _} -> View.CLI.startNewWindow()
      {:unix, :darwin} -> "MacOS not supported yet"
      {:unix, _} -> "Linux not supported yet"
    end
    assert thing == "DOPE"
  end

  @tag :skip
  test "browser_open (OS dependent)" do
    assert "DOPE" == View.CLI.startNewWindow()
  end



  describe "displayPlacements(board)" do
    test "starting position" do
      placements = Board.startingPosition()
      #assert View.displayBoard(brd) == String.reverse("♜♞♝♛♚♝♞♜\n♟︎♟︎♟︎♟︎♟︎♟︎♟︎♟︎\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n♙♙♙♙♙♙♙♙\n♖♘♗♕♔♗♘♖\n")
      assert View.CLI.displayPlacements(placements, :orange) == "♜♞♝♚♛♝♞♜♟︎♟︎♟︎♟︎♟︎♟︎♟︎♟︎◼◻◼◻◼◻◼◻◻◼◻◼◻◼◻◼◼◻◼◻◼◻◼◻◻◼◻◼◻◼◻◼♙♙♙♙♙♙♙♙♖♘♗♔♕♗♘♖"
      #"♖♘♗♔♕♗♘♖\n♙♙♙♙♙♙♙♙\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n♟︎♟︎♟︎♟︎♟︎♟︎♟︎♟︎\n♜♞♝♚♛♝♞♜\n"
      assert View.CLI.displayPlacements(placements, :blue) == "♖♘♗♕♔♗♘♖♙♙♙♙♙♙♙♙◼◻◼◻◼◻◼◻◻◼◻◼◻◼◻◼◼◻◼◻◼◻◼◻◻◼◻◼◻◼◻◼♟︎♟︎♟︎♟︎♟︎♟︎♟︎♟︎♜♞♝♛♚♝♞♜"
      #"♖♘♗♔♕♗♘♖\n♙♙♙♙♙♙♙♙\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n♟︎♟︎♟︎♟︎♟︎♟︎♟︎♟︎\n♜♞♝♚♛♝♞♜\n"
    end
  end

  describe " CLI display" do
    test "displayBoard" do
      brd = Board.createBoard() |> Map.put_new(:turn, :blue)
      _placements = brd.placements
      assert capture_io("vs",
      fn -> View.CLI.displayBoard(brd, :blue)
    end) == "ORDER: :orange, :blue\nTO_PLAY::blue\nNo impalable squares.\nAVAILABLE CASTLES:  Orange - both, Blue - both\nTURN: 1, Moves since pawn move, capture or castle: 0\n"
    end
  end
end
