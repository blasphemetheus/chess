defmodule Board do
  require BoardError
  import Location
  @maxSide 8
  @minSide 3
  @firstColor :orange
  @secondColor :blue
  #@validPieces [:pawn, :bishop, :knight, :rook, :queen, :king]

  defstruct board_state: [], first_color: :orange, second_color: :blue, progressable: true

  @doc """
  make the board with no pieces on it, just the layout of the board with tiles
  """
  def makeBoard(columns, rows) when columns < @minSide or columns > @maxSide or rows < @minSide or rows > @maxSide do
    raise BoardError, message: "invalid number of rows or columns, needs to be within 3 to 8 rows and columns"
  end

  def makeBoard(columns, rows) do
    recMakeBoard(columns, rows)
  end

  #defp recMakeBoard(0, _), :do []
  #defp recMakeBoard(_, 0), :do []
  def recMakeBoard(cols, rows) when cols == 0 or rows == 0, do: []

  def recMakeBoard(cols, rows) do
    one_rank = List.duplicate(:mt, cols) # for generating one row of columns
    List.duplicate(one_rank, rows) # for generating the rows
  end

  @doc """
  place one piece on the board
  """
  def placePiece(_board, _formal_location, _pieceColor, pieceType) when pieceType not in [:pawn, :bishop, :knight, :rook, :queen, :king] do
    raise ArgumentError, message: "not a valid piecetype"
  end
  def placePiece(_board, _formal_location, pieceColor, _pieceType) when pieceColor not in [:orange, :blue] do
    raise ArgumentError, message: "the piece color is not a valid color"
  end
  def placePiece(board, formal_location, pieceColor, pieceType) do
    if pieceType == :pawn do
      board_dimensions = board |> boardSize()
      if inRankUpZone(board_dimensions, formal_location, pieceColor) do
        raise BoardError, message: "cannot place a pawn in the rankUpZone, invalid placement"
      end
      # "nice! pawn is not in rankupzone, continue trying to place"
    end
    # "nice! not a pawn continue please"

    unless fLocationIsEmpty(board, formal_location) do
      raise BoardError, message: "cannot place a piece in a non-empty zone"
    end
    # "nice! the zone is empty"

    replace_at(board, formal_location, {pieceColor, pieceType})
  end

  def replace_at(board, {f_col, f_row} = f_location, {pieceColor, pieceType}) when is_atom(f_col) and is_integer(f_row) do
    replace_at(board, dumbLocation(f_location), {pieceColor, pieceType})
  end

  def replace_at(board, {f_col, f_row} = f_location, :mt)  when is_atom(f_col) and is_integer(f_row) do
    replace_at(board, dumbLocation(f_location), :mt)
  end

  def replace_at(board, {row, col}, :mt) when is_integer(row) and is_integer(col) do
    rank = board |> reverseRanks |> Enum.at(row)
    new_rank = List.replace_at(rank, col, :mt)

    reverseRanks(List.replace_at(reverseRanks(board), row, new_rank))
  end

  def replace_at(board, {row, col}, {pieceColor, pieceType}) when is_integer(row) and is_integer(col) do
    rank = board |> reverseRanks |> Enum.at(row) # [[:mt,:mt,:mt],[:mt,:mt,:mt],[:mt,:mt,:mt]]
    new_rank = List.replace_at(rank, col, {pieceColor, pieceType})

    reverseRanks(List.replace_at(reverseRanks(board), row, new_rank))
  end

  def fLocationIsEmpty(board, {_formal_col, _formal_row} = formal_location) do
    dLocationIsEmpty(board,
       dumbLocation(formal_location))
  end

  def reverseBoard(board), do: board |> reverseColumns|> reverseRanks

  def reverseRanks(board), do: Enum.reverse(board)

  def reverseColumns(board), do: Enum.map(board, fn x -> Enum.reverse(x) end)

  def dLocationIsEmpty(board, d_location) do
    case at(board, d_location) do
      :mt -> true
      _ -> false
    end
  end

  def at(board, {row, col}) when is_integer(row) and is_integer(col) do
    rank = reverseRanks(board) |> Enum.at(row)
    Enum.at(rank, col)
  end

  def at(board, {f_col, f_row} = formal_location) when is_integer(f_row) and is_atom(f_col) do
    at(board, dumbLocation(formal_location))
  end

  def at(board, anything) do
    anything
  end

  @doc """
  given a board, returns the board size as a dimensions matrix (so like {3, 4} for 3 columns, 4 rows)
  """
  def boardSize(board) do
    row = length(board)

    cond do
      row < 3 -> raise BoardError, message: "no rows in board"
      row > 8 -> raise BoardError , message: "board has too many objects (rows)"
      true -> "nice!"
    end

    col = length(List.first(board))

    cond do
      col < 3 -> raise BoardError, message: "too few columns in board"
      col > 8 -> raise BoardError, message: "too many columns in board"
      true -> "nice!"
    end

    {col, row}
  end

  # Location: {:a, 1 }, {0, 0}
  @doc """
  returns whether the given location is in the rankupZone for that piece color given a boardSize dimension matrix (col then row)
  """
  def inRankUpZone(board_dimensions, location, pieceColor) do
    # rank up zone is the last and top most for orange (equivalent of white in chess)

    {_columns, rows} = board_dimensions
    {_specific_col, specific_row} = location

    case pieceColor do
      @firstColor -> rows == specific_row # in specific row which is specified in board_dimensions
      @secondColor -> specific_row == 1 # in specific row which must be 1 (or 0 if start from 0)
    end
  end

  #psuedo in rank up zone
  #if the pieceColor is orange (the one that goes first), figure out how whether the zone is on the top rank
  #(so in a 3x3 board, row 3 and in an 8x8 board row 8)
  # and if it is blue (the second color), determine whether the zone is on the bootom rank (so in a 3x3 board, row 1, always row 1 i guess)

  @doc """
  place one tile on the tileary
  """
  def placeTile(tileary, tileType, formal_location) do
    if isReplacingTile(tileary, formal_location) do
      raise BoardError, message: "existing tile at location to place tile"
    end

    tileary ++ [{tileType, formal_location}]
  end

  # a tileary is a collection of unusual tile placements that takes the form of a list of placements:
  # a placement is an item of the form {formal_location, tileType}. Only one formal_location have a an assigned tileType
  def isReplacingTile([], _formal_location), do: false
  def isReplacingTile(tileary, new_location) do
    Enum.reduce(tileary, false, fn {_tileType, existing_location} = _placement, acc -> existing_location == new_location or acc end)
  end

  @doc """
  creates a starting position, placing all tiles,
  then all starting pieces on the board
  """
  def startingPosition do
    makeBoard(8,8)
    # orange pawns
    |> placePiece({:a, 2}, :orange, :pawn)
    |> placePiece({:b, 2}, :orange, :pawn)
    |> placePiece({:c, 2}, :orange, :pawn)
    |> placePiece({:d, 2}, :orange, :pawn)
    |> placePiece({:e, 2}, :orange, :pawn)
    |> placePiece({:f, 2}, :orange, :pawn)
    |> placePiece({:g, 2}, :orange, :pawn)
    |> placePiece({:h, 2}, :orange, :pawn)
    # blue pawns
    |> placePiece({:a, 7}, :blue, :pawn)
    |> placePiece({:b, 7}, :blue, :pawn)
    |> placePiece({:c, 7}, :blue, :pawn)
    |> placePiece({:d, 7}, :blue, :pawn)
    |> placePiece({:e, 7}, :blue, :pawn)
    |> placePiece({:f, 7}, :blue, :pawn)
    |> placePiece({:g, 7}, :blue, :pawn)
    |> placePiece({:h, 7}, :blue, :pawn)
    # orange pieces
    |> placePiece({:a, 1}, :orange, :rook)
    |> placePiece({:b, 1}, :orange, :knight)
    |> placePiece({:c, 1}, :orange, :bishop)
    |> placePiece({:d, 1}, :orange, :queen)
    |> placePiece({:e, 1}, :orange, :king)
    |> placePiece({:f, 1}, :orange, :bishop)
    |> placePiece({:g, 1}, :orange, :knight)
    |> placePiece({:h, 1}, :orange, :rook)
    # blue pieces
    |> placePiece({:a, 8}, :blue, :rook)
    |> placePiece({:b, 8}, :blue, :knight)
    |> placePiece({:c, 8}, :blue, :bishop)
    |> placePiece({:d, 8}, :blue, :queen)
    |> placePiece({:e, 8}, :blue, :king)
    |> placePiece({:f, 8}, :blue, :bishop)
    |> placePiece({:g, 8}, :blue, :knight)
    |> placePiece({:h, 8}, :blue, :rook)
  end

  @doc """
  makes a move on behalf of a player
  """
  def move(board, starting_location, ending_location, _playerColor, _pieceType) do
    moving_piece = at(board, starting_location)
    ending_location_state = at(board, {ending_location})

    board
    |> replace_at(starting_location, :mt)
    |> replace_at(ending_location, moving_piece)
  end

  @doc """
  create a board from a bunch of _initial_ piece placements
  reject placements that result in boards where: tiles are not in a 3x3 to 8x8 or anywhere in between
  (so 3x8 is valid), pawns are in their colors rankupzone, either king is in stalemate or checkmate
  """
  def createBoardInitial(list_of_placements) do
    makeBoard(8, 8)
    |> recCreateBoardInitial(list_of_placements)
  end

  defp recCreateBoardInitial(board, []), do: board

  defp recCreateBoardInitial(brd, [{f_loc, pieceColor, pieceType}] = lop) do
    brd
    |> placePiece(f_loc, pieceColor, pieceType)
  end

  defp recCreateBoardInitial(brd, [{f_loc, pieceColor, pieceType} = head | tail] = lop) do
    brd
    |> placePiece(f_loc, pieceColor, pieceType)
    |> recCreateBoardInitial(tail)
  end

  @doc """
  creates a state from a bunch of intermediate player placements
  operation should _try to_ reject placements that result in boards with
  piece placements that couldn't have possibly resulted from a series of turns
  (ie pawn in the first row, two bishops on the same color and 8 pawns)
  """
  def createBoard(lop) do
    createBoardInitial(lop)
  end

  # might need other operations to design these, consider making public if there's
  # a need for players or refs (via rule checkers) to use them

  # the board cannot enforce rules. Baking some basic constraints into the boards'
  # presence is ok to do. Above methods give examples as to what those are

  def printBoard(board) do
    Enum.map(board, fn
      x -> printRank(x)
      end) |> to_string()
  end

  def listBoard(board) do
    Enum.map(board, fn
      x -> Enum.map(x, fn
        y -> translate(y) end) end)
  end

  def printRank(rank) do
    Enum.map(rank, fn
      x -> translate(x) end) ++ ["\n"] |> to_string()
  end

  def translate({pieceColor, pieceType})do
    Tile.renderTile(pieceColor, pieceType)
  end

  def translate(:mt), do: Tile.renderTile(:blue)
end
