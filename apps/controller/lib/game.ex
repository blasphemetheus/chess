defmodule GameRunner do
  import GameException
  import Board
  import Player
  import View.CLI

  @resolutions [:win, :loss, :drawn, :bye]
  @end_reasons [:checkmate, :stalemate, :resignation, :timeout, :draw, :disconnection, :other]
  @play_types [:vs, :online, :cpu_vs_cpu, :human_vs_cpu, :cpu_vs_human]

  defstruct board: %Board{}, turn: :orange, first: %Player{color: :orange}, second: %Player{color: :blue}, status: :built, history: [], resolution: nil, reason: nil


  def assignLocalOrRemote(player) do
    cond do
      String.contains?(player, "local") -> :local
      String.contains?(player, "remote") -> :remote
      true -> raise "Invalid Online player type"
    end
  end


  # TODO IMPORTED
    @doc """
  Given a tag and an opponent tag, ,
  """
  def playLocal(tag \\ "BRAG", opponent \\"GRED") do
    View.displays(:local, tag, opponent)
    Board.startingPosition()
    |> showGameStatus({tag, opponent}, {[],[]}, 0, 0)
    |> playTurn(tag, "first")
    |> showGameStatus({tag, opponent}, {[],[]}, 0, 0)
    |> playTurn(opponent, "second")
    |> showGameStatus({tag, opponent}, {[],[]}, 0, 1)
  end

  # asks the local user indicated for a move, the io.get prompts etc
  def playTurn(board, localUserTag, color) do
    IO.puts("It is now the turn of #{localUserTag}, please enter your move in the following format (<location> <location> <piececolor> <piecetype>):\n")
    input = IO.gets("")
    i = String.trim(input)
    {:ok, {s_loc, e_loc, playerColor, pieceType}} = parseMove(i)

    board
    |> move(s_loc, e_loc, playerColor, pieceType)
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
  def runGame([player1, player2] = _both_players, [first_pt, second_pt] = _playTypeList) do
    %GameRunner{
      board: Board.createBoard(),
      turn: :orange,
      first: %Player{type: first_pt, color: :orange, tag: player1},
      second: %Player{type: second_pt, color: :blue, tag: player2},
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
      isDrawn(game.board, game.turn) -> %GameRunner{game | resolution: :drawn}
      isWon(game.board, game.turn) -> %GameRunner{game | resolution: :loss}
      isLost(game.board, game.turn) -> %GameRunner{game | resolution: :win}
      true -> raise GameException, message: "Game is not a draw, win or loss, cannot find resolution #{inspect(game)}}"
    end
  end

  def findEndingReason(game) do
    case game.resolution do
      :drawn -> %GameRunner{game | reason: :draw}
      :loss -> %GameRunner{game | reason: :checkmate}
      :win -> %GameRunner{game | reason: :checkmate}
      _ -> raise GameException, message: "Game is not a draw, win or loss, cannot find ending reason #{inspect(game)}"
    end
  end

  def convertToOutcome(game) do
    %Outcome{players: [game.first, game.second], resolution: game.resolution, reason: game.reason}
  end

  def isDrawn(board, color) do
    Board.isOver(board, color)
  end

  def isWon(board, color) do
    Board.isOver(board, color)
  end

  def isLost(board, color) do
    Board.isOver(board, color)
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
    View.CLI.showGameBoardAs(game.board, game.turn)
    if Board.isOver(game.board, game.turn) do
      %{game | status: :ended} # game is over, so we can stop taking turns
      raise GameException, message: "Game is over, cannot take turns"
    else
      case game.turn do
        :orange -> playTurn(game, game.first)
        :blue -> playTurn(game, game.second)
      end
    end
  end

  @doc """
  recursively deals with a game, and a color, and maybe a player,
  returning at the end of it a game that has taken that turn,
  asked for input when necessary, or calculated moves
  """
  def playTurn(game, player) do
    case player.type do
      :human -> playHumanTurn(game, player)
      :cpu -> playCPUTurn(game, player)
      _ -> raise GameException, message: "Invalid player type #{inspect(player)}"
    end
  end

  @doc """
  given a game struct, a turn (color), and a player
  (type, so like :human etc)
  plays one human turn

  """
  def playHumanTurn(game, player) do
    turn = game.turn
    #View.CLI.displays(:game_board, game.board |> Board.printBoard(), turn)
    View.CLI.displays(:turn_intro, turn, player)
    # play a turn
    move1_raw = View.CLI.ask(:game_turn)

    # parse the move
    {:ok, parsed1} = case Parser.parseMove(move1_raw) do
      {:ok, parsed1} -> {:ok, parsed1}
      {:error, e} -> raise ArgumentError, message: "#{inspect(e)} Move inputted parsed Incorrectly: #{inspect(move1_raw)}"
    end

    {start_loc, end_loc, type_at_loc} = parsed1

    # validate the move
    valid = Referee.validateMove(game.board, start_loc, end_loc, turn, type_at_loc)
    # if valid, make the move
    if valid do
      #new_board = Board.makeMove(game.board, move1)
      new_board = Board.move!(game.board, start_loc, end_loc, turn, type_at_loc)
      takeTurns(%{game | board: new_board, turn: nextTurn(game.turn)})
    else
      # if invalid, prompt the player again
      move2 = IO.gets("Enter a move: ")
      # validate the move
      valid_two = Referee.validateMove(game.board, move2)

      # if invalid again, the player resigns
      if valid_two do
        #new_board = Board.makeMove(game.board, move2)
        new_board = Board.move(game.board, start_loc, end_loc, turn, type_at_loc)
        takeTurns(%{game | board: new_board, turn: nextTurn(game.turn)})
      else
        raise GameException, message: "Player resigned via bad input: #{inspect(move1_raw)} and #{inspect(move2)}}"
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

  def playCPUTurn(game, player) do
    turn = game.turn
    selected_move = possible_moves(game.board, turn)
    |> Enum.random()

    dbg()

    new_board = Board.makeMove(game.board, selected_move)
    takeTurns(%{game | board: new_board, turn: nextTurn(turn)})

    # generate a move
    # validate the move
    # if valid, make the move
    # if invalid, generate a new move
    # if invalid again, the player resigns

    # if the player resigns, end the game
    # if the player times out, end the game as a timeout loss
  end

  def playTurnOnline(game) do
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

  def playTurnOnline(game, turn, player) do
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

  def nextTurn(:blue), do: :orange
  def nextTurn(:orange), do: :blue
  ##### Online Game Functions #####

  def finish(game), do: %GameRunner{game | status: :ended}
end
