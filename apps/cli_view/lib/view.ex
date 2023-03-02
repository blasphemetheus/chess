defmodule View do
  import Board
  import TCPServer
  @doc """
  displays the board as ascii

    iex> displayBoard(Board.startingPosition())
    "hey"

    iex> displayBoard(Board.scotch())
    "ha"
  """
  def displayBoard(board) do
    output = printBoard(board)
    IO.puts(output)
  end

  @doc """
  The best entry point for new users, gathers the players tag and redirects
  to online, vs, or cpu chess games. your options are "online" "vs" and "cpu"

    iex> welcome()
    "Hello! What is your player tag?\n"
    "online\n"

    iex> welcome()
    "Hello! What is your player tag?\n"
    "vs\n"

    iex> welcome()
    "Hello! What is your player tag?\n"
    "cpu\n"
  """
  def welcome() do
    t = IO.gets("\nHello! What is your player tag?\n")
    tag = String.trim(String.upcase(t))
    IO.puts("")

    playType = IO.gets("What's good #{tag}? Let's play chess.\n\rHow would you like to play it? pick one of (online, vs, cpu)\n")
    IO.puts("")
    pt = String.trim(String.downcase(playType))
    case pt do
      "online" ->
        IO.puts(address(tag) <> "Preparing for online play ...\n")
        playOnline(tag)
      "vs" ->
        o = IO.gets(address(tag) <> "What is the name of your opponent?\n")
        opponent = String.trim(String.upcase(o))
        playLocal(tag, opponent)
      "cpu" ->
        lvl = IO.gets(address(tag) <> "What level opponent would you like to play vs?\n")
        level = String.trim(lvl)
        playCPU(tag, level)
      _ -> "I didn't catch that. Bye!"
    end
  end

  def address(tag, postscript \\ "\n") do
    case Enum.random(1..10) do
      1 -> "Hey there #{tag}!"
      2 -> "Greetings Sibling #{tag}."
      3 -> "Howdy #{tag}"
      4 -> "Suahh #{tag}"
      5 -> "Wuts good #{tag}?"
      6 -> "Oh it's you #{tag}. (Yikes)"
      7 -> "<stares deep into your soul> Hmmb. #{tag}. You have come."
      8 -> "B*tch you're back? Ok. Ok. #{tag} I hope you're happy "
      9 -> "At Last! Mein Frend #{tag} has returned to us!"
      10 -> "Spare Me Oh Glorious #{tag}!!! Forgive me my sins!!!"
    end <> postscript
  end

  def playOnline(tag, socket \\ "127.0.0.1", port \\ 4321) do
    tcpConnect(socket, port)
  end

  def playLocal(tag, opponent) do
    IO.puts("\n\nLOCAL VERSUS:\n#{tag} vs #{opponent}")
    Board.startingPosition()
    |> showGameStatus({tag, opponent}, {[],[]}, 0, 0)
    |> playTurn(tag, "first")
    |> showGameStatus({tag, opponent}, {[],[]}, 0, 0)
    |> playTurn(opponent, "second")
    |> showGameStatus({tag, opponent}, {[],[]}, 0, 1)
  end

  # given a string which could be malicious or whatever, or lie about any number of things, pull out the four things for a move
  def parseMove(input) do
    result = [_start_loc, _end_loc, _pieceColor, _pieceType] = String.split(input)
    |> List.to_tuple()

    {:ok, result}
  end

  # asks the local user indicated for a move, the io.get prompts etc
  def playTurn(board, localUserTag, color) do
    IO.puts("It is now the turn of #{localUserTag}, please enter your move in the following format (<location> <location> <piececolor> <piecetype>):\n")
    input = IO.gets("")
    {:ok, {s_loc, e_loc, playerColor, pieceType}} = parseMove(input)

    board
    |> move(s_loc, e_loc, playerColor, pieceType)
  end

  def showGameStatus(board, {tag, opponent} = tags, taken, time_elapsed, turns) do
    IO.puts(metadata(tags, taken, time_elapsed, turns))
    board
    |> displayBoard()
  end

  def metadata({first, second}, {first_taken, second_taken}, time, turns)do
    "Players: #{first} VS #{second}\n" <> "Pieces taken: [#{first_taken}] VS [#{second_taken}]\n" <>
    "Time Elapsed: #{time}\n" <> "Turn: #{turns}\n"
  end

  def playerMetadata(player, color, taken, to_play, time) do
    "tag: #{player}\ncolor: #{color}\n, Pieces Taken: [#{taken}]\n Plays Next: #{to_play}\nTime Elapsed: #{time}"
  end

  def playCPU(tag, level) do

  end

  # should be in a different app probably (for handling tcp connections)
  def tcpConnect(socket, port) do
    "hmmb"
  end
end
