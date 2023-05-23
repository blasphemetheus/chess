defmodule GameRunner do
  @moduledoc """
  All about the GameRunner
  """
  #import GameError
  import Board
  #import Player
  import View.CLI

  #@resolutions [:win, :loss, :drawn, :bye]
  #@end_reasons [:checkmate, :stalemate, :resignation, :timeout, :draw, :disconnection, :other]
  #@play_types [:vs, :online, :cpu_vs_cpu, :human_vs_cpu, :cpu_vs_human]

  defstruct board: %Board{},
            turn: :orange,
            first: %Player{color: :orange},
            second: %Player{color: :blue},
            status: :built,
            history: [],
            resolution: nil,
            reason: nil

  def assignLocalOrRemote(player) do
    cond do
      String.contains?(player, "local") -> :local
      String.contains?(player, "remote") -> :remote
      true -> raise "Invalid Online player type"
    end
  end

  @doc """
  Given a tag and an opponent tag, ,
  """
  def playLocal(tag \\ "BRAG", opponent \\ "GRED") do
    View.CLI.displays(:local, tag, opponent)

    Board.startingPosition()
    |> showGameStatus({tag, opponent}, {[], []}, 0, 0)
    |> playTurn(tag, "first")
    |> showGameStatus({tag, opponent}, {[], []}, 0, 0)
    |> playTurn(opponent, "second")
    |> showGameStatus({tag, opponent}, {[], []}, 0, 1)
  end

  # asks the local user indicated for a move, the io.get prompts etc
  def playTurn(board, localUserTag, color) do
    IO.puts(
      "It is now the turn of #{localUserTag}, please enter your move in the following format (<location> <location> <piececolor> <piecetype>):\n"
    )

    input = IO.gets("")
    i = String.trim(input)
    {:ok, {s_loc, e_loc, playerColor, pieceType}} = parseMove(i)

    case playerColor do
      ^color -> board |> move(s_loc, e_loc, playerColor, pieceType)
      _any -> raise ArgumentError, message: "tried to move another's piece"
    end
  end

  def randomLevel() do
    Enum.random(0..1)
  end

  def createGame(first_playertype, second_playertype, tag, opp_tag) do
    %GameRunner{
      board: Board.createBoard(),
      turn: :orange,
      first: %Player{type: first_playertype, color: :orange, tag: tag, lvl: 1},
      second: %Player{type: second_playertype, color: :blue, tag: opp_tag, lvl: 1},
      status: :in_progress,
      history: [],
      resolution: nil,
      reason: nil
    }
  end
  # returns an outcome in the format [{player1, player2}, resolution]
  #   where if player1 wins, resolution is :win, if player2 wins, resolution is :loss,
  #   if drawn, resolution is :drawn
  # possible @resolutions: [win, loss, drawn]
  # possible playTypes: [human, cpu, online, human_vs_cpu]
  @doc """
  Starts a game given a list of two player_tags and a playType (:vs, :online, :cpu).
  :vs = [:human v :human]
  :cpu = [:human v :computer]
  :pcu = [:computer v :human]
  :simulation = [:computer v :computer]
  :trolled = [:online v :computer]
  :trolling= [:computer v :online]
  :online = [:online v :online]
  :playnet = [:online v :human]
  :netplay = [:human v :online]

  First, the appropriate stuff is displayed on the screen via the View interface,
  then the players make their moves. How input is taken/generated depends
  on what sort of players there are in the game.
  There are human, cpu, and online players.
  CPUs generate their moves in the moment, while humans make the computer prompt for input, which
  the human gives via cli or via mouseclicks or button-presses depending on the view
  Online will just have to wait.
  """
  def runGame([player1, player2], playType) when playType |> is_atom(),
    do: runGame([player1, player2], [playType, playType])

  def runGame([player1, player2] = _both_players, [first_pt, second_pt] = _playTypeList) do
    %GameRunner{
      board: Board.createBoard(),
      turn: :orange,
      # randomLevel()
      first: %Player{type: first_pt, color: :orange, tag: player1, lvl: 1},
      second: %Player{type: second_pt, color: :blue, tag: player2, lvl: 1},
      status: :in_progress,
      history: [],
      resolution: nil,
      reason: nil
    }
    |> gameStart()
    # PUT THE STARTING GAME IO STUFF HERE , LIKE FOR LOGS THIS WILL BE WHERE IT GOES
    # takeTurns is the main loop of the game
    |> takeTurns()
    # the take turns loop has ended, so the game cannot continue, now we must figure out who won and then why
    |> findResolution()
    # once we find the resolution, we can find the _reason_ the game ended
    # honestly this seems backwards, the board tells us when the game is over, it already knows why. So why would we be
    # asking the board something it's already had the opportunity to provide?
    |> findEndingReason()
    |> convertToOutcome()

    # %Outcome{players: [game.first, game.second], resolution: findResolution(game.board), reason: findEndingReason(game.board)}
  end

  # Outcome%{players: [player1, player2], resolution: :loss, reason: :checkmate}
  # Outcome%{players: [player1, player2], resolution: :drawn, reason: :stalemate}
  # Outcome%{players: [player1, player2], resolution: :win, reason: :resignation}

  def findResolution(game) do
    cond do
      isLost(game.board, game.turn) ->
        %GameRunner{game | resolution: :win}

      isWon(game.board, game.turn) ->
        %GameRunner{game | resolution: :loss}

      isDrawn(game.board, game.turn) ->
        %GameRunner{game | resolution: :drawn}

      true ->
        raise GameError,
          message: "Game is not a draw, win or loss, cannot find resolution #{inspect(game)}}"
    end
  end

  def findEndingReason(game) do
    reason =
      case game.resolution do
        :drawn ->
          cond do
            Board.isStalemate(game.board, game.turn) ->
              :stalemate

            Board.isInsufficientMaterial(game.board) ->
              :insufficient_material

            Board.isFiftyMoveRepitition(game.board, game.turn) ->
              :fifty_move_repitition

            true ->
              :agreed
          end

        :loss ->
          if Board.isCheckmate(game.board, game.turn) do
            :checkmate
          else
            :resignation
          end

        :win ->
          if Board.isCheckmate(game.board, game.turn) do
            :checkmate
          else
            :resignation
          end

        _ ->
          :other
      end

    case reason do
      :other ->
        raise GameError,
          message: "Game is not a draw, win or loss, cannot find ending reason #{inspect(game)}"

      _any ->
        true
    end

    %GameRunner{game | reason: reason}
  end

  def convertToOutcome(game) do
    %Outcome{players: [game.first, game.second], resolution: game.resolution, reason: game.reason}
  end

  def isDrawn(board, color) do
    Board.isDraw(board, color)
  end

  def isWon(board, color) do
    Board.isCheckmate(board, Board.otherColor(color))
  end

  def isLost(board, color) do
    Board.isCheckmate(board, color)
  end

  @doc """
  Given a game struct, make sure the initial startGame text is displayed,
  and returns game, depending on the mode, could ask for input here etc
  """
  def gameStart(game) do
    View.CLI.displays(:game_intro, game.first, game.second, :normal)
    game
  end

  @doc """
  Initiates the turn-taking phase of the game. The main loop!
  Whomever's turn it is, that player will be prompted (by their color)
  to make a move. First there will be a check to see if the game is over.
  It shouldn't be, but say someone gave you a position and asked to evaluate it
  You'd have to be able to identify whether it's playable or not.
  If it's over we should raise an error or a fuss somehow. Let's do that now.
  OK, but if the game can still be played, play a turn
  """
  def takeTurns(game) do
    case game.first.type do
      :computer -> View.CLI.showGameBoardAs(game.board, game.first.color)
      _other -> View.CLI.showGameBoardAs(game.board, game.turn)
    end

    if GameRunner.isOver(game) do
      # game is over, so we can stop taking turns
      %{game | status: :ended}
    else
      case game.turn do
        :orange -> playTurn(game, game.first)
        :blue -> playTurn(game, game.second)
      end
      |> takeTurns()
    end
  end

  @doc """
  given a board and history, return
  """
  def isOver(game) do
    Board.isOver(game.board, game.turn) or
    isThreeFoldRepitition(game.board, game.turn, game.history)
  end

  def isThreeFoldRepitition(board, to_play, history) do
    placements = board.placements
    first_castleable = board.first_castleable
    second_castleable = board.second_castleable
    position = {to_play, first_castleable, second_castleable, placements}

    historyContainsTwoEqualPositions(history, position)
  end

  def historyContainsTwoEqualPositions(history_list, position_tuple) do
    case Enum.member?(history_list, position_tuple) do
      true ->
        new_h = List.delete(history_list, position_tuple)

        case Enum.member?(new_h, position_tuple) do
          true -> true
          false -> false
        end

      false ->
        false
    end
  end

  @doc """
  recursively deals with a game, and a color, and maybe a player,
  returning at the end of it a game that has taken that turn,
  asked for input when necessary, or calculated moves
  """
  def playTurn(game, player) do
    case player.type do
      :vs -> playHumanTurn(game, player)
      :human -> playHumanTurn(game, player)
      :computer -> playCPUTurn(game, player.lvl)
      :cpu -> playCPUTurn(game, player.lvl)
      _ -> raise GameError, message: "Invalid player type #{inspect(player)}"
    end
    |> appendToHistory(game)
  end

  @doc """
  Given a new_game and an old_game, appends the old_game to the new_game
  """
  def appendToHistory(new_game, old_game) do
    %{new_game | history: [old_game | new_game.history]}
  end

  @doc """
  given a board and turn to help parse, asks the user for input and returns a move answer
  that parses correctly, giving them two tries and then erroring out
  """
  def askAndCorrectlyParse(board, turn) do
    move1_raw = View.CLI.ask(:game_turn)
    # parse the move
    {:ok, parsed} =
      case Parser.parseMoveCompare(move1_raw, board, turn) do
        {:ok, parsed1} ->
          {:ok, parsed1}

        {:error, e} ->
          View.CLI.displayError(:move_input_error, e)
          move2_raw = View.CLI.ask(:game_turn)

          case Parser.parseMoveCompare(move2_raw, board, turn) do
            {:ok, parsed2} -> {:ok, parsed2}
            {:error, e} -> raise ArgumentError, message: "entered incorrect input #{e}"
          end
      end

    parsed
  end

  @doc """
  given a game struct, a turn (color), and a player
  (type, so like :human etc)
  plays one human turn

  """
  def playHumanTurn(game, player) do
    turn = game.turn
    # View.CLI.displays(:game_board, game.board |> Board.printBoard(), turn)
    View.CLI.displays(:turn_intro, turn, player)
    # play a turn
    {start_loc, end_loc, type_at_loc, promote_to} =  askAndCorrectlyParse(game.board, game.turn)

    # validate the move
    valid = Referee.validateMove(game.board, start_loc, end_loc, turn, type_at_loc, promote_to)
    # if valid, make the move
    if valid do
      # new_board = Board.makeMove(game.board, move1)
      {:ok, new_board} = Board.move(game.board, start_loc, end_loc, turn, type_at_loc, promote_to)
      %{game | board: new_board, turn: nextTurn(game.turn)}
    else
      {start_loc2, end_loc2, type_at_loc2, promote_to} = askAndCorrectlyParse(game.board, game.turn)

      valid_two = Referee.validateMove(game.board, start_loc2, end_loc2, turn, type_at_loc2, promote_to)

      # if invalid again, the player resigns
      if valid_two do
        # new_board = Board.makeMove(game.board, move2)
        {:ok, new_board} = Board.move(game.board, start_loc2, end_loc2, turn, type_at_loc2, promote_to)
        %{game | board: new_board, turn: nextTurn(game.turn)}
      else
        raise GameError, message: "Player resigned via bad input"
      end
    end

    # prompt the player for a move
    # validate the move
    # if valid, make the move
    # if invalid, prompt the player again
    # if invalid again, the player resigns

    # if the player resigns, end the game
    # if the player times out, end the game as a timeout loss
  end

  def playCPUTurn(game, 0) do
    turn = game.turn

    possible = possible_moves_of_color(game.board, turn)

    # {start_loc, end_loc} = selected_move = possible |> Enum.random()
    {start_loc, end_loc, promote_to} =
      case possible |> List.first() do
        {start_loc, end_loc} -> {start_loc, end_loc, :nopromote}
        {_start_loc, _end_loc, _promote_to} = x -> x
      end

    {^turn, piece_type} = Board.get_at(game.board.placements, start_loc)
    {:ok, new_board} = Board.move(game.board, start_loc, end_loc, turn, piece_type, promote_to)
    %{game | board: new_board, turn: nextTurn(turn)}
    # for some reason start_loc can end up being the atom :board, troubleshoot
    # generate a move
    # validate the move
    # if valid, make the move
    # if invalid, generate a new move
    # if invalid again, the player resigns

    # if the player resigns, end the game
    # if the player times out, end the game as a timeout loss
  end

  def playCPUTurn(game, 1) do
    turn = game.turn

    possible = possible_moves_of_color(game.board, turn)

    {start_loc, end_loc, promote_to} =
      case possible |> Enum.random() do
        {start_loc, end_loc} -> {start_loc, end_loc, :nopromote}
        {_start_loc, _end_loc, _promote_to} = x -> x
      end

    {^turn, piece_type} = Board.get_at(game.board.placements, start_loc)

    {:ok, new_board} = Board.move(game.board, start_loc, end_loc, turn, piece_type, promote_to)
    %{game | board: new_board, turn: nextTurn(turn)}
  end

  def playTurnOnline(_game) do
    # prompt the player for a move
    # validate the move
    # if valid, make the move
    # if invalid, prompt the player again

    # if the player resigns, end the game
    # if the player times out, end the game

    # if the player disconnects, end the game
    # if the player is disconnected, end the game
    # if the player is disconnected, end the game
  end

  def playTurnOnline(_game, _turn, _player) do
    # prompt the player for a move
    # validate the move
    # if valid, make the move
    # if invalid, prompt the player again

    # if the player resigns, end the game
    # if the player times out, end the game

    # if the player disconnects, end the game
    # if the player is disconnected, end the game
    # if the player is disconnected, end the game
    {:error, :unsupported}
  end

  def nextTurn(:blue), do: :orange
  def nextTurn(:orange), do: :blue
  ##### Online Game Functions #####

  def finish(game), do: %GameRunner{game | status: :ended}
end
