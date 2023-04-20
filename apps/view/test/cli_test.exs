defmodule ViewCLITest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import View.CLI
  # doctest CLIView
  # excellent resource http://daisymolving.github.io/2016/09/10/testing-input-output.html
  # if contemplating mocking -> no
  # https://blog.appsignal.com/2023/04/11/an-introduction-to-mocking-tools-for-elixir.html

  test "showGameBoardAs (orange and blue)" do
    assert capture_io(fn ->
      View.CLI.showGameBoardAs(%Board{}, :blue)
    end) == "blueboard"

    assert capture_io(fn ->
      View.CLI.showGameBoardAs(%Board{}, :orange)
    end) == "orangeboard"
  end

  test "displays :game_intro, with Bob, Georgina, and the default starting board" do
    bob = %Player{type: :human, color: :orange, tag: "Bob"}
    georgina = %Player{type: :cpu, color: :blue, tag: "Georgina"}
    assert capture_io(fn ->
      View.CLI.displays(:game_intro, bob, georgina, %Board{})
    end) == "LET THE GAME BEGIN!!!\nFACING OFF TODAY:\nWE HAVE THE VENERABLE Bob OF TYPE human\nBATTLING AGAINST Georgina OF TYPE cpu.\n\nWHO SHALL BE THE VICTOR?\nTHE STARTING POSITION IS A NORMAL GAME:"
  end

  test "displays turn intro" do
    bob = %Player{type: :human, color: :orange, tag: "Bob"}
    georgina = %Player{type: :cpu, color: :blue, tag: "Georgina"}

    assert capture_io(fn ->
      View.CLI.displays(:turn_intro, :red, georgina)
    end) == "The Turn is: red, with player: #{inspect(georgina)}"

    assert capture_io(fn ->
      View.CLI.displays(:turn_intro, :blue, georgina)
    end) == "The Turn is: blue, with player: #{inspect(georgina)}"

    assert capture_io(fn ->
      View.CLI.displays(:turn_intro, :orange)
    end) == "The Turn is: orange"
  end

  test "displayGameBoard" do
    assert capture_io(fn ->
      View.CLI.displayGameBoard(Board.startingPosition() |> Board.printPlacements())
    end) == "♜♞♝♛♚♝♞♜\n♟︎♟︎♟︎♟︎♟︎♟︎♟︎♟︎\n◻◼◻◼◻◼◻◼\n◼◻◼◻◼◻◼◻\n◻◼◻◼◻◼◻◼\n◼◻◼◻◼◻◼◻\n♙♙♙♙♙♙♙♙\n♖♘♗♕♔♗♘♖\n"
  end

  test "ask :game_turn" do
    assert capture_io("d4", fn ->
      View.CLI.ask(:game_turn)
    end) == "Enter your move in the format 'd2 d4', 'd4' if a pawn move 'xd4' if a pawn move and taking on d4, etc:\nd4\n"

    assert capture_io([input: "d4", capture_prompt: false], fn ->
      View.CLI.ask(:game_turn)
    end) == "d4\n"

    {result, output} = with_io("d4", fn ->
      View.CLI.ask(:game_turn)
    end)
    assert result == "d4"
    assert output == "Enter your move in the format 'd2 d4', 'd4' if a pawn move 'xd4' if a pawn move and taking on d4, etc:\nd4\n"
  end

  test "ask, retry" do
    assert View.CLI.retriable_ask(:game_turn, -1) == "resign"

    assert capture_io([input: "help", capture_prompt: false], fn ->
      View.CLI.retriable_ask(:game_turn, 0)
    end) == "\n"

    assert capture_io([input: ["help", "help"], capture_prompt: false], fn ->
      View.CLI.retriable_ask(:game_turn, 1)
    end) == "resign"

    {result, output} = with_io("d4", fn ->
      View.CLI.retriable_ask(:game_turn, 1)
    end)
    assert result == "d4"
    assert output == "Enter your move\nd4\n"
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
      assert View.CLI.displayPlacements(placements, :orange) == "♖♘♗♔♕♗♘♖\n♙♙♙♙♙♙♙♙\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n♟︎♟︎♟︎♟︎♟︎♟︎♟︎♟︎\n♜♞♝♚♛♝♞♜\n"
      assert View.CLI.displayPlacements(placements, :blue) == "♖♘♗♔♕♗♘♖\n♙♙♙♙♙♙♙♙\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n◼◼◼◼◼◼◼◼\n♟︎♟︎♟︎♟︎♟︎♟︎♟︎♟︎\n♜♞♝♚♛♝♞♜\n"
    end
  end

  describe " CLI display" do
    test "displayBoard" do
      brd = Board.createBoard() |> Map.put_new(:turn, :blue)
      placements = brd.placements
      assert capture_io("vs",
      fn -> View.CLI.displayBoard(placements)
    end) == "Hello! What is your player tag?\n vs"
    end
  end
end
