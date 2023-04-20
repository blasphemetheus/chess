defmodule View.CLI do
  #@pipe Application.compile_env(:my_app, View.CLI, []) |> Keyword.get(:pipe, IO)
  # the above is for using application configuration to pass around modules
  # then in testing, use a test module, and otherwise use the real one

  @doc """
  Starts a new CLI window given a path,
  what actually happens depends on the OS

  For Windows it will open a Fullscreen Powershell and Cmd Prompt
  """
  def startNewWindow() do
    # CMD FOR OPENING A FULLSCREEN PS AND CMD PROMPT
    # wt --focus --maximized ; split-pane -p "Command Prompt"

    {cmd, args, options} = case :os.type() do
      {:win32, _} ->
        IO.puts("WINDOWS DEVICE DETECTED")
        "start C:\\\\tools\\Cmder\\Cmder.exe" |> String.to_charlist() |> :os.cmd()
        #System.cmd("start" ["%USERPROFILE%\\Documents\\cmder\\Cmder.exe"], into: IO.stream())
        #IO.puts("test2")
      {:unix, :darwin} ->
        IO.puts("MACOS DEVICE DETECTED")
        # STUB
      {:unix, _} ->
        IO.puts("LINUX DEVICE DETECTED")
        # STUB
    end

    System.cmd(cmd, args, options)
    :os.type()
    System.shell("ls")
    # THIS IS FOR WINDOWS,
    # https://learn.microsoft.com/en-us/windows/terminal/command-line-arguments?tabs=windows

    # FOR LINUX,
    # https://lucasfcosta.com/2019/04/07/streams-introduction.html
  end

  # retyped in from https://blog.sethcorker.com/question/how-do-you-detect-what-os-you-re-running-in-elixir/
  # meant as an example more than anything
  def browser_open(path) do
    {cmd, args, options} = case :os.type() do
      {:win32, _} ->
        IO.puts("WINDOWS DEVICE DETECTED")
        dirname = Path.dirname(path)
        basename = Path.basename(path)
        {"cmd", ["/c", "start", basename], [cd: dirname]}

      {:unix, :darwin} ->
        IO.puts("MACOS DEVICE DETECTED")
        # STUB, just opens directory
        {"open", [path], []}
      {:unix, _} ->
        IO.puts("LINUX DEVICE DETECTED")
        # STUB, just opens directory
        {"xdg-open", [path], []}
    end
    System.cmd(cmd, args, options)
  end

  @doc """
  Given a Board struct, pull out nested placements list and color,
  makes a string representation of those placements and
  calls a fn to display it on the screen
  """
  def showGameBoardAs(board, :blue) do
    contents_str = board.placements |> Board.reversePlacements() |> Board.printPlacements()

    displayGameBoard(contents_str)
  end

  def showGameBoardAs(board, :orange) do
    contents_str = board.placements |> Board.printPlacements()

    displayGameBoard(contents_str)
  end
  ############################################################



  def displayBoard(board, color, first_p, second_p) do
    displayOrder(board.order)
    displayTurn(color, {first_p, second_p})
    displayPlacements(board.placements, color)
    # displayPlacements(board.placements, color, board.impalable_square)
    displayImpalable(board.impalable_loc)
    displayCastleable({board.first_castleable, board.second_castleable})
    displayMoveCounter(board.fullmoves, board.halfmove_clock)
  end

  def displayGame(game) do
    displayPlayers(game)
    displayBoard(game.placements, game.turn, game.first, game.second)
  end

  def displayPlayers(game) do
    IO.puts("#{inspect(game)}")
  end

  def displayImpalable(impale_square) do
    IO.puts("The pawn at #{inspect(impale_square)} is impalable (en passant)")
  end

  def displayCastleable({first_c, second_c}) do
    IO.puts("#{first_c} #{second_c}")
  end

  def displayMoveCounter(fullmoves, halfmove_clock) do
    IO.puts("#{fullmoves} #{halfmove_clock}")
  end

  def displayTurn(color, {first_p, second_p}) do
    IO.puts("#{color}, #{first_p} #{second_p} ")
  end

  def displayOrder({first, second}), do: IO.puts("ORDER: #{inspect(first)}, then #{inspect(second)}")

  def displayPlacements(placements, color \\ :orange)
  def displayPlacements(placements, :orange) do
    placements
    |> Board.reversePlacements()
    |> Board.printPlacements()
  end
  def displayPlacements(placements, :blue) do
    placements
    |> Board.printPlacements()
  end

  def displayPlacements(placements, color, impale_square) do
    placements
    |> insertSprintedPawn(impale_square, Board.otherColor(color))
    |> displayPlacements(color)
  end

  def insertSprintedPawn(board, impale_square, color) do
    behind_square = Board.behind(board, impale_square, color)
    board
    |> Board.replace_at(behind_square, {color, :pawn})
  end
############################################################


  # parse a location of the format string "d5" etc
  def parseLocation(raw_location) do
    l = String.graphemes(raw_location)
    case l do
      [col, row] when col in ["a", "b", "c", "d", "e", "f", "g", "h"] and row in ["1", "2", "3", "4", "5", "6", "7", "8"] -> {col, String.to_integer(row)}
      yes -> raise ArgumentError, message: "you done #{inspect yes} messed up"
    end
  end

  def parseColor(raw_color) do
    case raw_color do
      "orange" -> :orange
      "blue" -> :blue
      _ -> raise ArgumentError, message: "Expected: valid playerColor, Got:#{raw_color}"
    end
  end

  def parsePiece(raw_piece) do
    case raw_piece do
      "pawn" -> :pawn
      "knight" -> :knight
      "bishop" -> :bishop
      "rook" -> :rook
      "queen" -> :queen
      "king" -> :king
      _ -> raise ArgumentError, message: "Expected: valid pieceType, Got: #{raw_piece}"
    end
  end

  # given a string which could be malicious or whatever, or lie about any number of things, pull out the four things for a move
  def parseMove(input) do
    {start_loc, end_loc, pieceColor, pieceType} = String.split(input)
    |> List.to_tuple()

    p_start_loc = parseLocation(start_loc)
    p_end_loc = parseLocation(end_loc)
    p_pieceColor = parseColor(pieceColor)
    p_pieceType = parsePiece(pieceType)


    parsed = {p_start_loc, p_end_loc, p_pieceColor, p_pieceType}
    # raise ArgumentError, message: "hello #{inspect parsed}"

    {:ok, parsed}
  end

  def showGameStatus(board, {tag, opponent} = tags, taken, time_elapsed, turns) do
    displays(:metadata, tags, taken, time_elapsed, turns)
    board
    |> displayBoard(board.order[0], tag, opponent)
  end

  ##################################################

  def displays(:game_intro, first_player, second_player, starting_pos) when is_struct(first_player) and is_struct(second_player) do
    IO.puts("LET THE GAME BEGIN!!!")
    IO.puts("FACING OFF TODAY:")
    IO.puts("WE HAVE THE VENERABLE #{first_player.tag} OF TYPE #{
      first_player.type}")
    IO.puts("BATTLING AGAINST #{second_player.tag} OF TYPE #{
        second_player.type}.")
    IO.puts("")
    IO.puts("WHO SHALL BE THE VICTOR?")
    IO.puts("THE STARTING POSITION IS #{inspect(starting_pos)}:")
  end

  def displays(atom, second_arg, player \\ nil)
  def displays(:turn_intro, turn, player) do
    case player do
      nil -> IO.puts("The Turn is: #{inspect(turn)}")
      _other -> IO.puts("The Turn is: #{inspect(turn)}, with player: #{inspect(player)}")

    end
  end

  def displays(:local, tag, opponent) do
    IO.puts("\n\nLOCAL VERSUS:\n#{tag} vs #{opponent}")
  end

  def displays(:metadata, tags, taken, time_elapsed, turns) do
    IO.puts(metadata(tags, taken, time_elapsed, turns))
  end
  def metadata({first, second}, {first_taken, second_taken}, time, turns)do
    "Players: #{first} VS #{second}\n" <> "Pieces taken: [#{first_taken}] VS [#{second_taken}]\n" <>
    "Time Elapsed: #{time}\n" <> "Turn: #{turns}\n"
  end
  def playerMetadata(player, color, taken, to_play, time) do
    "tag: #{player}\ncolor: #{color}\n, Pieces Taken: [#{taken}]\n Plays Next: #{to_play}\nTime Elapsed: #{time}"
  end

  @doc """
  Given a string representation of the placements,
  prints out the placements line by line (in chunks of 8)
  to the CLI
  """
  def displayGameBoard(board_contents) do
    # IO.puts("TO_PLAY: #{inspect(:orange)}, BOARD: #{inspect(board_contents)} dope")
    #Parser.parseFor(board_contents, "\n")
    #String.splitter(board_contents, "\n")
    #|> Enum.each(fn x -> IO.puts(x) end)
    board_contents
    |> String.graphemes()
    |> Enum.chunk_every(8)
    |> Enum.map(&(&1 |> List.to_string()))
    |> Enum.each(fn x -> IO.puts(x) end)
  end


  @doc """
  Asks CLI for move, but if help is returned, displays a message,
  also n is how many tries you have left after this,
  if it is zero, it is your last try, if you hit your last try,
  you resign automatically
  """
  def retriable_ask(:game_turn, -1), do: "resign"
  def retriable_ask(:game_turn, n) when n > -1 do
    asked = ask(:game_turn)

    if asked == "help" do
      IO.puts("Enter your move in the format 'd2 d4', 'd4' if a pawn move 'xd4' if a pawn move and taking on d4, etc:\n")
      retriable_ask(:game_turn, n - 1)
    else
      asked
    end
  end

  @doc """
  Asks cli for move, and makes it upper case and trims it of newlines and spaces
  """
  def ask(:game_turn) do
    raw = IO.gets("Enter a move:\n")
    IO.puts("")
    raw |> String.upcase() |> String.trim()
  end

  # TODO REMAKE THIS FUNCTIONALITY
  # def move_validate(atom, atom_response) do
  #   ## (asking again if bad input, and taking abbreviations, etc)
  #   recur_bool = true
  #   case move_validate(atom, atom_response) do
  #     {:error, e} ->
  #       case recur_bool do
  #         true ->
  #           IO.puts(e)
  #           ask(:try_again)
  #           #ask(atom, false)
  #         false -> raise ArgumentError, message: e
  #       end
  #     {:ok, _} -> atom_response
  #   end
  # end
end
