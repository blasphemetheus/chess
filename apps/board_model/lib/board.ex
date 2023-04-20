defmodule Board do
  @moduledoc """
  This is an implementation of a chess board.
  There's two types of functions right now, those that use the Board struct and those
  that use the list structure that the board is stored in.

  The Board struct is probably the most useful, but it will fundamentally rely on the list structure
  in the placements field of the struct. placements is a list of lists, where each list is a rank.
  """
  ## IMPORTS ##
  require BoardError
  import Location
  #import MoveError

  ## MODULE ATTRIBUTES ## (useful for constants among other things)
  @maxSide 8
  @minSide 3
  @firstColor :orange
  @secondColor :blue
  @piecetypes [:pawn, :bishop, :knight, :rook, :queen, :king]
  @move_only [:sprint, :march, :castle, :promote]
  @castling_priveleges [:short, :long, :both, :none, :left, :right]
  # short and long and left and right are disagreeing notions of how a board's orientation works,
  # but it's simple enough to support both, so I'm going to (it's a bad idea)
  # short is always kingside, long is always queenside, but if you're orange,
  # queenside is to the left, while it's on the right if blue
  # orange kingside is to the right, blue kingside to the left

  ## GUARDS ## (preconditions for fns)
  # checks if a column and row are in the valid lengths for the board
  defguard good_col_n_row(columns, rows) when @maxSide >= columns and columns >= @minSide and @maxSide >= rows and rows >= @minSide
  # checks if a piecetype is real
  defguard valid_piecetype(pieceType) when pieceType in @piecetypes
  # checks if color is real
  defguard valid_color(color) when color in [@firstColor, @secondColor]

  @doc """
  Define %Board{} struct.

  It has placements (the implementation of locations), a representation of the
  order of the two colors (order), some way of checking whether the game is over (stalemate, checkmate),
  a way to check for en passant, and a way to check for castling.

  This is the struct that represents the board. It has a list of lists, where each list is a rank.
  And each item in the rank is a tuple of atoms = {color, pieceType} or an atom (:mt)

  This struct will probably be added to with the FEN stuff as I create it
  """
  defstruct placements: [], order: [@firstColor, @secondColor], move_is_possible: [true, true], impale_square: :no_impale, first_castleable: :both, second_castleable: :both, halfmove_clock: 0, fullmove_number: 1
  ## %Board{placements: rec2DList(columns, rows)}

  ### FUNCTIONS ###

  @doc """
  make the board with no pieces on it, just the layout of the board with tiles
  """
  def make2DList(columns, rows) when good_col_n_row(columns, rows), do: rec2DList(columns, rows)
  def make2DList(columns, rows), do: raise BoardError, message: "bad # of rows or columns, Expected 3 to 8 got Row:#{rows}, Col:#{columns}"

  @doc """
  Recursively makes the list of lists that represents the board placements
  maybe make private
  """
  def rec2DList(cols, rows) when cols == 0 or rows == 0, do: []
  def rec2DList(cols, rows), do: :mt |> List.duplicate(cols) |> List.duplicate(rows)

  @doc """
  insert a piece into the placements list of lists given a location ie {:a, 1}
  as well as a piece color and pieceType. All these need to be valid.
  Also pawns can't go in the first or last rank because rules.
  Can't place a piece in a non-empty zone.
  """
  def placePiece(_brd, _f_loc, _p_clr, pieceType) when not valid_piecetype(pieceType) do
    raise ArgumentError, message: "not a valid piecetype: #{inspect(pieceType)}"
  end

  def placePiece(_board, _formal_location, pieceColor, _pieceType) when not valid_color(pieceColor) do
    raise ArgumentError, message: "color of piece invalid. Got: #{inspect(pieceColor)}"
  end

  def placePiece(board, f_loc, p_clr, :pawn) do
    dimensions = board |> boardSize()
    if inRankUpZone(dimensions, f_loc, p_clr) do
      raise BoardError, message: "trying to place pawn in rankUpZone: invalid loc #{inspect(f_loc)} color #{inspect(p_clr)}"
    end
    if inKingRank(dimensions, f_loc, p_clr) do
      raise BoardError, message:  "trying to place pawn in king rank: invalid loc #{inspect(f_loc)} color #{inspect(p_clr)}"
    end
    replace_at(board, f_loc, {p_clr, :pawn})
  end

  def placePiece(board, formal_location, pieceColor, pieceType) do
    unless fLocationIsEmpty(board, formal_location) do
      raise BoardError, message: "cannot place a piece in a non-empty zone"
    end
    # "nice! the zone is empty"

    replace_at(board, formal_location, {pieceColor, pieceType})
  end

  @doc """
  given placements, a location, and a playerColor.
  returns a new placements with the indicated replaced with an :mt
  """
  def remove_at(board, location) do
    board
    |> replace_at(location, :mt)
  end

  @doc """
  given placements, a location, and tuple of color and piecetype,
  returns a new group of placements, with the replacements made
  """
  def replace_at(board, {f_col, f_row} = f_location, {pieceColor, pieceType}) when is_atom(f_col) and is_integer(f_row) do
    replace_at(board, dumbLocation(f_location), {pieceColor, pieceType})
  end

  def replace_at(board, {f_col, f_row} = f_location, :mt)  when is_atom(f_col) and is_integer(f_row) do
    replace_at(board, dumbLocation(f_location), :mt)
  end

  # dumb location is tuple {int, int}
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

  # TODO : debug, honestly I think this implementation of placing piece is broken, but
  # it'll work for my purposes for now. I'm just reversing these lists but not in the right moments
  # I bet this wouldn't pass tests
  def fLocationIsEmpty(board, {_formal_col, _formal_row} = formal_location) do
    dLocationIsEmpty(board, dumbLocation(formal_location))
  end

  ## the actual implementation !!!
  def dLocationIsEmpty(board, d_location) do
    case get_at(board, d_location) do
      :mt -> true
      _ -> false
    end
  end

  @doc """
  We need to be able to grab what's at a location based on the list
  structure that it is stored on (the {row, col} interpretation) {ie {3, 0}
  AND we need to be able to grab what's at a given formal location
  (the {col, row} interpretation){ie {:a, 1}}
  """
  def get_at(board, {row, col}) when is_integer(row) and is_integer(col) do
    #OH MY, THIS IS WORRYING AT BEHAVIOR, I FORGOT ABOUT THE REVERSING SHENANIGANS
    # MUST REFACTOR BECAUSE WOW, NOT INTUITIVE AT ALL, fortunately
    # ill just lock it behind this black box of `at` and refactor l8r
    # dealing only with formal locations until then

    #rank = board |> Enum.at(row)
    #Enum.at(rank, col)
    rank = reverseRanks(board) |> Enum.at(row)
    Enum.at(rank, col)
  end

  def get_at(board, {f_col, f_row} = formal_location) when is_integer(f_row) and is_atom(f_col) do
    get_at(board, dumbLocation(formal_location))
  end

  @doc """
  given a board, returns the board size as a dimensions matrix (so like {3, 4} for 3 columns, 4 rows)
  """
  def boardSize(board) do
    row = length(board)

    col = case row do
      0 -> 0
      _ when is_list() -> length(List.first(board))
    end

    check = fn (col, row) when good_col_n_row(col, row) -> {col, row} end

    check.(col, row)
  end

  # Location: {:a, 1 } {0, 0} (a dumb location would be {0, 7})
  @doc """
  returns whether the given location is in the rankupZone for that piece color given a boardSize dimension matrix (col then row)
  """
  def inRankUpZone(board_dimensions, location, pieceColor) do
    ## TODO : DEBUG THIS (dumb locations are not intuitive,
    #         {:a, 1} does NOT translate to {0, 0} as it turns out)
    #         (it translates to {0, 7} because of the way the board is stored)

    # rank up zone is the last and top most for orange (equivalent of white in chess)

    {_columns, rows} = board_dimensions
    {_specific_col, specific_row} = location

    case pieceColor do
      @firstColor -> rows == specific_row # in specific row which is specified in board_dimensions
      @secondColor -> specific_row == 1 # in specific row which must be 1 (or 0 if start from 0)
    end
  end

  @doc """
  returns whether the given location is in the king rank for that piece color given
  a boardSize dimension matrix (col then row)
  The king rank is the first row for the first player and last row for the second.
  The row that appears closest to the player when playing across the board.
  """
  def inKingRank({_num_cols, num_rows} = _dimensions, {_col, row} = _loc, p_clr) do
    case p_clr do
      @firstColor -> 1 == row
      @secondColor -> num_rows == row
    end
  end

  @doc """
  given placements, loc and a playerColor
  return the placement at the loc behind the loc provided
  """
  def behind(placements, {e_col, e_row}, :orange) do
    get_at(placements, {e_col, e_row - 1})
  end

  def behind(placements, {e_col, e_row}, :blue) do
    get_at(placements, {e_col, e_row + 1})
  end

  @doc """
  returns whether the location provided is in front of a pawn
  on the provided placements, with the provided pieceColor
  """
  def in_front_of_enemy_pawn(placements, loc, color) do
    opponent = otherColor(color)
    case behind(placements, loc, color) do
      {:pawn, ^opponent} -> true
      _any -> false
    end
  end

  @doc """
  given a playerColor and moveType,
  return the spot in the castle where the rook is
  """
  def rookspot(:orange, :shortcastle), do: {:h, 1}
  def rookspot(:orange, :longcastle), do: {:a, 1}
  def rookspot(:blue, :shortcastle), do: {:h, 8}
  def rookspot(:blue, :longcastle), do: {:a, 8}

  @doc """
  given placements, and a start and end location,
  return the travel spot between them that the king passes through on a castle
  """
  def castle_travel_spot({s_col, s_row}, {e_col, _e_row}) when e_col != s_col do
    new_col = cond do
      e_col > s_col -> column_to_int(e_col) - 1 |> int_to_column()
      e_col < s_col -> column_to_int(e_col) + 1 |> int_to_column()
    end

    {new_col, s_row}
  end

  @doc """
  A collection of validation functions, ENSURES
  They return true if validated and raise a MoveError otherwise
  """
  def ensurePlacementNotEmpty(placement) do
    case placementNotEmpty(placement) do
      true -> true
      false -> raise MoveError, message: "moving piece is empty, cannot move empty"
    end
  end

  def placementNotEmpty(placement), do: placement != :mt

  def ensurePlacementAgreesWithProvidedInfo({moving_color, moving_type} = moving_piece, playerColor, pieceType, start_loc) do
    case placementAgreesWithProvidedInfo({moving_color, moving_type}, playerColor, pieceType, start_loc) do
      true -> true
      false -> raise MoveError,
        message: "Mismatch: the placement of the piece at the LOCATION #{
        inspect(start_loc)} and the provided info do not match, PROVIDED: #{
        inspect({playerColor, pieceType})} PRESENT : #{inspect(moving_piece)}"
    end
  end

  def placementAgreesWithProvidedInfo({moving_color, moving_type} = moving_piece, playerColor, pieceType, _start_loc) do
    is_tuple(moving_piece) and moving_color == playerColor and moving_type == pieceType
  end

  def ensureNotTakingOwnPiece({e_color, e_type}, moving_color) do
    case notTakingOwnPiece({e_color, e_type}, moving_color) do
      true -> true
      false -> raise MoveError, message: "Cannot take your own piece"
    end
  end

  def notTakingOwnPiece({e_color, _e_type}, moving_color) do
    e_color != moving_color
  end

  def ensureMoveTypeValid(movetype, start_loc, end_loc, playerColor, pieceType) do
    case moveTypeValid(movetype) do
      true -> true
      false -> raise MoveError,
        message: "invalid move, STARTING #{inspect(start_loc)}  GOING TO #{
        inspect(end_loc) } with COLOR: #{inspect(playerColor)} PIECETYPE #{
        inspect(pieceType)}"
    end
  end

  def moveTypeValid(movetype), do: movetype != :invalid

  def ensurePromoteTypeValid(pr_type, movetype) do
    case promoteTypeValid(pr_type, movetype) do
      true -> true
      false -> raise MoveError, message: "Trying to promote invalidly, PROMOTE_TYPE : #{
        inspect(pr_type)}, MOVETYPE : #{inspect(movetype)}"
    end
  end

  def promoteTypeValid(pr_type, movetype) do
    case pr_type do
      :nopromote -> movetype not in [:promote, :promotecapture]
      _other -> pr_type in [:knight, :queen, :rook, :bishop] and  movetype in [:promote, :promotecapture]
    end
  end

  def ensurePassivityMatchesResult(movetype, end_loc_placement) do
    case passivityMatchesResult(movetype, end_loc_placement) do
      true -> true
      false -> cond do
        movetype in [:capture, :promotecapture] ->
          raise MoveError, message: "Move #{inspect(movetype)}cannot be performed as there is no piece to take"
        movetype in [:march, :sprint, :promote] ->
          raise MoveError, message: "Move #{inspect(movetype)} cannot be performed because you cannot take with this move"
      end
    end
  end

  def passivityMatchesResult(moveType, end_loc_placement) do
    cond do
      moveType in [:capture, :promotecapture] ->
        captureIsTaking(moveType, end_loc_placement)
      moveType in [:march, :sprint, :promote] ->
        passiveIsMoving(moveType, end_loc_placement)
    end
  end

  def captureIsTaking(_movetype, :mt), do: false
  def captureIsTaking(_movetype, {_color, _type}), do: true
  def passiveIsMoving(_movetype, :mt), do: true
  def passiveIsMoving(_movetype, {_color, _type}), do: false

  def ensureRushingMovesHaveNoPiecesInBetween(moveType, placements, end_loc, start_loc) do
    case rushingMovesHaveNoPiecesInBetween(moveType, placements, end_loc, start_loc) do
      true -> true
      false -> raise MoveError, message:  "move #{moveType
        } invalid as there is at least one piece in the way"
    end
  end

  def rushingMovesHaveNoPiecesInBetween(moveType, placements, end_loc, start_loc) do
    if moveType in [:vertical, :diagonal, :horizontal, :longcastle, :shortcastle, :sprint] do
      pieces_between(placements, end_loc, start_loc) |> length() == 0
    else
      true
    end
  end

  def ensureImpalingCaptureInFrontOfEnemyPawn(movetype, impalable_loc, placements, end_loc, player_color) do
    case impalingCaptureInFrontOfEnemyPawn(movetype, impalable_loc, placements, end_loc, player_color) do
      true -> true
      false -> raise MoveError, message: "Trying to impale but not in front of enemy pawn"

    end
  end

  def impalingCaptureInFrontOfEnemyPawn(movetype, impalable_loc, placements, end_loc, playerColor) do
    cond do
      impalable_loc == end_loc and movetype == :capture ->
        in_front_of_enemy_pawn(placements, end_loc, playerColor)
      true -> true
    end
  end

  @doc """
  Given a location, a color, and placements, returns
  whether the location is in front of an enemy pawn
  """
  def in_front_of_enemy_pawn(placements, {col, row}, :orange) do
    case Board.get_at(placements, {col, row - 1}) do
      {:pawn, :blue} -> true
      any -> false
    end
  end

  def in_front_of_enemy_pawn(placements, {col, row}, :blue) do
    case Board.get_at(placements, {col, row + 1}) do
      {:pawn, :orange} -> true
      any -> false
    end
  end

  def ensureCastleNotSpent(movetype, castle_dirs) do
    case castleNotSpent(movetype, castle_dirs) do
      true -> true
      false -> raise MoveError, message: "Not castleable with Available Castles: #{inspect(castle_dirs)}, and movetype #{movetype}."
    end
  end

  def castleNotSpent(:longcastle, castle_dirs) do
    castle_dirs in [:queenside, :both]
  end

  def castleNotSpent(:shortcastle, castle_dirs) do
    castle_dirs in [:kingside, :both]
  end

  def ensureKingCheckDoesntDisruptCastle(movetype, placements, player_color) do
    case kingCheckDoesntDisruptCastle(movetype, placements, player_color) do
      true -> true
      false -> raise MoveError, message: "Not castleable, king in check"
    end
  end

  def kingCheckDoesntDisruptCastle(movetype, placements, player_color) do
    movetype in [:longcastle, :shortcastle] and
    not isCheck(placements, player_color)
  end

  def ensureKingNotPassingThroughCheckForCastle(playerColor, moveType, placements, travel_spot) do
    case kingNotPassingThroughCheckForCastle(playerColor, moveType, placements, travel_spot) do
      true -> true
      false -> raise MoveError, message: "In Between Castling Location #{inspect(travel_spot)
      } is threatened by the opposing player's pieces, castling in this direction impossible for now"
    end
  end

  def kingNotPassingThroughCheckForCastle(playerColor, moveType, placements, travel_spot) do
    (moveType == :shortcastle or moveType == :longcastle) and
    travel_spot not in threatens(placements, otherColor(playerColor))
  end

  def ensureRookspotContainsRookForCastle(playerColor, moveType, placements, rook_spot) do
    case rookspotContainsRookForCastle(playerColor, moveType, placements, rook_spot) do
      true -> true
      false -> raise MoveError, message: "uncastleable because no rook at #{inspect(rook_spot)}"
    end
  end

  def rookspotContainsRookForCastle(playerColor, moveType, placements, rook_spot) do
    that_rook = case get_at(placements, rook_spot) do
      {^playerColor, :rook} -> true
      _ -> false
    end
  end

  def ensureNoPiecesBetweenRookAndKingForCastle(playerColor, moveType, placements, start_loc, rook_spot) do
    case noPiecesBetweenRookAndKingForCastle(playerColor, moveType, placements, start_loc, rook_spot) do
      true -> true
      false -> raise MoveError, "move #{moveType} invalid as there is a piece in the way"
    end
  end

  def noPiecesBetweenRookAndKingForCastle(playerColor, moveType, placements, start_loc, rook_spot) do
    pieces_between(placements, rook_spot, start_loc) |> length() == 0
  end

  def ensureNewBoardDoesNotPutYouInCheck(new_board, playerColor) do
    case newBoardDoesNotPutYouInCheck(new_board, playerColor) do
      true -> true
      false -> raise MoveError, message: "Move results in your king threatened with check: invalid"
    end
  end

  def newBoardDoesNotPutYouInCheck(new_board, playerColor) do
    not Board.isCheck(new_board, playerColor)
  end

  def helpMove!(:king, placements, start_loc, end_loc, playerColor, _end_loc_placement, moveType, _impalable_loc, _promote_type, castleable_dirs) when moveType == :longcastle or moveType == :shortcastle do
    # a castling move
    ensureCastleNotSpent(moveType, castleable_dirs)
    ensureKingCheckDoesntDisruptCastle(moveType, placements, playerColor)

    rook_spot = rookspot(playerColor, moveType)

    ensureRookspotContainsRookForCastle(playerColor, moveType, placements, rook_spot)

    that_rook = get_at(placements, rook_spot)

    ensureNoPiecesBetweenRookAndKingForCastle(playerColor, moveType, placements, start_loc, rook_spot)

    travel_spot = castle_travel_spot(start_loc, end_loc)

    ensureKingNotPassingThroughCheckForCastle(moveType, placements, playerColor, travel_spot)

    castlingMove(placements, start_loc, end_loc, {playerColor, :king}, rook_spot, travel_spot, that_rook)
  end

  def helpMove!(:king, placements, start_loc, end_loc, playerColor, _end_loc_placement, _moveType, _impalable_loc, _promote_type, _castle) do
    typicalMove(placements, start_loc, end_loc, {playerColor, :king})
  end

  def helpMove!(:knight, placements, start_loc, end_loc, playerColor, _end_loc_placement, _moveType, _impalable_loc, _promote_type, _castle) do
    typicalMove(placements, start_loc, end_loc, {playerColor, :knight})
  end

  def helpMove!(:pawn, placements, start_loc, end_loc, player_color, _end_loc_placement, moveType, impalable_loc, _promote_type, _castle) when moveType == :capture and impalable_loc == end_loc and impalable_loc != :noimpale do
    # impaling
    # ignore passivity because it is a capture on empty space affecting the pawn behind the empty space
    ensureImpalingCaptureInFrontOfEnemyPawn(moveType, impalable_loc, placements, end_loc, player_color)

    pawn_behind_loc = behind(placements, end_loc, player_color)

      # impale AKA enpassant
    # perform impale, with side effect of pawn behind where you're going being removed
    impalingMove(placements, start_loc, end_loc, {:pawn, player_color}, pawn_behind_loc)
  end

  def helpMove!(:pawn, placements, start_loc, end_loc, player_color, end_loc_placement, moveType, _impalable_loc, promote_type, _castle) when moveType == :promote or moveType == :promotecapture do
    # promoting
    #promoting = promote_type != :nopromote
    # already did in move fn but hey
    #ensurePromoteTypeValid(promote_type, moveType)
    ensurePassivityMatchesResult(moveType, end_loc_placement)

    promotingMove(placements, start_loc, end_loc, {:pawn, player_color}, promote_type)
  end

  def helpMove!(:pawn, placements, start_loc, end_loc, player_color, end_loc_placement, moveType, _impalable_loc, _promote_type, _castle) when moveType == :promote or moveType == :promotecapture do
    # not promoting, not impaling
    ensurePassivityMatchesResult(moveType, end_loc_placement)

    typicalMove(placements, start_loc, end_loc, {player_color, :pawn})
  end

  # bishop, rook, queen, not (king, pawn, knight)
  def helpMove!(piece_type, placements, start_loc, end_loc, player_color, _end_loc_placement, moveType, _impalable_loc, _promote_type, _castle) do
    ensureRushingMovesHaveNoPiecesInBetween(moveType, placements, end_loc, start_loc)

    typicalMove(placements, start_loc, end_loc, {player_color, piece_type})
  end

  @doc """
  given a start loc, end loc, piece to move, and placements,
  performs a typical move, replacing the start_loc placement with :mt
  and replacing the end_loc with the moving_piece
  """
  def typicalMove(placements, start_loc, end_loc, moving_piece) do
    placements
    |> remove_at(start_loc)
    |> replace_at(end_loc, moving_piece)
  end

  @doc """
  given a start loc, end loc, piece to move, and placements,
  as well as a rook_spot, travel_spot (where rook will end up) and that_rook placement,
  performs a castling move, replacing the start_loc placement with :mt
  and replacing the end_loc with the moving_piece, and doing the same with
  """
  def castlingMove(placements, start_loc, end_loc, moving_piece, rook_spot, travel_spot, that_rook) do
    placements
    |> typicalMove(start_loc, end_loc, moving_piece)
    |> typicalMove(rook_spot, travel_spot, that_rook)
  end

  @doc """
  """
  def impalingMove(placements, start_loc, end_loc, moving_piece, pawn_behind_loc) do
    placements
    |> remove_at(start_loc)
    |> replace_at(end_loc, moving_piece)
    |> remove_at(pawn_behind_loc)
  end

  def promotingMove(placements, start_loc, end_loc, moving_piece, promote_type) do
    placements
    |> replace_at(start_loc, promote_type)
    |> replace_at(end_loc, moving_piece)
  end

  @doc """
  returns a tuple {ok: placements} containing the placements of the completed move
  or an error tuple {error: reason} if the move is invalid
  """
  def move!(placements, start_loc, end_loc, playerColor, pieceType, castleable_directions \\ :neither, promote_type \\ :nopromote, impalable_loc \\ :noimpale) do
    moving_piece = get_at(placements, start_loc)


    ensurePlacementNotEmpty(moving_piece)

    ensurePlacementAgreesWithProvidedInfo(moving_piece, playerColor, pieceType, start_loc)

    end_loc_placement = get_at(placements, end_loc)

    ## they call my moving bool, 'passive' in some other chess engines,
    ## taking is then labeled 'active'
    moving = end_loc_placement == :mt
    taking = not moving

    taking and ensureNotTakingOwnPiece(end_loc_placement, playerColor)

    moveType = Moves.retrieveMoveType(start_loc, end_loc, pieceType, playerColor)

    ensureMoveTypeValid(moveType, start_loc, end_loc, playerColor, pieceType)

    # so we know that just based on locations as well as color and type of the piece, we have plausible moves
    # Now we compare the conditions of the board with what movetype we're doing,

    ensureRushingMovesHaveNoPiecesInBetween(moveType, placements, end_loc, start_loc)

    ensurePromoteTypeValid(promote_type, moveType)

    # movetype_validator =
    # move_fn
    new_board = helpMove!(pieceType, placements, start_loc, end_loc, playerColor, end_loc_placement, moveType, impalable_loc, promote_type, castleable_directions)

    ensureNewBoardDoesNotPutYouInCheck(new_board, playerColor)

    new_board
  end

  def move(placements, start_loc, end_loc, playerColor, pieceType, castling \\ :neither, promote \\ :nopromote, impale_loc \\ :noimpale) do
    try do
      new_placements = move!(placements, start_loc, end_loc, playerColor, pieceType, castling, promote, impale_loc)
      {:ok, new_placements}
    catch
      reason -> {:error, reason}
    end
  end

  @doc """
  makes a move given two locations (start and end), as well as {player_color and piece_type} or
  if you do not provide those, the placement at start is moved
  """
  def move_no_checks(placements, start_loc, end_loc, player_color, piece_type) do
    placements
    |> replace_at(start_loc, :mt)
    |> replace_at(end_loc, {player_color, piece_type})
  end

  def move_no_checks(placements, start_loc, end_loc) do
    moving_piece = get_at(placements, start_loc)

    placements
    |> replace_at(start_loc, :mt)
    |> replace_at(end_loc, moving_piece)
  end

  @doc """
  create a board from a bunch of _initial_ piece placements
  reject placements that result in boards where: tiles are not in a 3x3 to 8x8 or anywhere in between
  (so 3x8 is valid), pawns are in their colors rankupzone, either king is in stalemate or checkmate
  """
  def createBoardInitial(list_of_placements) do
    make2DList(8, 8)
    |> recCreateBoardInitial(list_of_placements)
  end

  @doc """
  Creates a board, ready to play chess on
  """
  def createBoard() do
    # %Board{
    #   placements: startingPosition(),
    #   order: [@firstColor, @secondColor],
    #   impale_square: :no_impale,
    #   first_castleable: :both,
    #   second_castleable: :both,
    #   halfmove_clock: 0,
    #   fullmove_number: 1,
    # }
    # aka
    %Board{
      placements: startingPosition()
    }
  end

  defp recCreateBoardInitial(board, []), do: board

  defp recCreateBoardInitial(brd, [{f_loc, pieceColor, pieceType}]) do
    brd
    |> placePiece(f_loc, pieceColor, pieceType)
  end

  defp recCreateBoardInitial(brd, [{f_loc, pieceColor, pieceType} | tail]) do
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

  def printPlacements(placements, line_sep \\ "\n") do
    placements
    |> Board.reverseRanks()
    #|> Enum.intersperse(:switch_tiles)
    |> Enum.map(fn
      x -> printRank(x, "\t") <> line_sep
      end) |> to_string() |> inspect()
    #Enum.intersperse()
    Tile.renderTile(:blue)
    Tile.renderTile(:orange)
    # we need nested tile colors to zip into the board
    Tile.nestedTileColors()
    # so we must zip TWICE (zip ranks, zip placements)
    |> Enum.zip_with(placements,
      fn (tile_color_rank, board_rank) ->
        Enum.zip_with(tile_color_rank, board_rank, fn
          tile_color, :mt -> tile_color
          _tile_color, not_empty -> not_empty
          end)
        end)
    ## |> Enum.map(fn x -> Enum.chunk_every(x, 2) |> List.to_tuple() end)
    |> Board.map_to_each(&translate/1)
    |> Enum.reduce("", fn x, accum -> accum <> Enum.reduce(x, "", fn item, acc -> acc <> item end) end)
  end

  def printFEN(board) do
    placement_str = printPlacements(board.placements, "")
  end

  def  blue_or_orange(true) do
    false
  end

  def listBoard(board) do
    Board.Utils.nested_convert_to_formal(board) |> Board.reverseRanks()
    |> Enum.map(fn
      x -> Enum.map(x, fn
        y -> translate(y) end) end)
  end

  def printRank(rank, sep \\ "\t")

  def printRank(rank, sep) do
    Enum.map(rank, fn
      x -> translate(x) <> sep end)
    |> to_string()
  end


  def translate(pieceColor, pieceType)do
    Tile.renderTile(pieceColor, pieceType)
  end

  def translate(:mt), do: Tile.renderTile(:blue)
  def translate({pieceColor, pieceType}) do
    Tile.renderTile(pieceColor, pieceType)
  end
  def translate(:blue), do: Tile.renderTile(:blue)
  def translate(:orange), do: Tile.renderTile(:orange)


  @doc """
  Returns true when the game is over by board-conditions
   (checkmate, stalemate, or insufficient material)
  """
  def isOver(board, to_play) do
    placements = board.placements
    isCheckmate(placements, to_play) or
    isStalemate(placements, to_play) or
    isInsufficientMaterial(placements)
  end

  @doc """
  Returns true when, (playing as the color indicated by to_play)
  the player is in checkmate
  """
  def isCheckmate(board, to_play) do
    isCheck(board, to_play) and # done
    kingImmobile(board, to_play) # done
    and noMovesResolvingCheck(board, to_play) # todo
  end

  @doc """
  Returns true when, (playing as the color indicated by to_play)
  the player is in stalemate
  """
  def isStalemate(board, to_play) do
    #   Complete (check)             todo                              todo                                    todo
    kingImmobile(board, to_play) and
    not isCheck(board, to_play) and
    noMovesResolvingCheck(board, to_play) and
    noPieceCanMove(board, to_play)
  end

  @doc """
  Returns true when the king is being threatened by the opposing player's pieces
  """
  def isCheck(board, to_play) do
    threatened = threatens(board, otherColor(to_play))
    king_loc = findKing(board, to_play)
    Enum.member?(threatened, king_loc)
  end

  @doc """
  Returns true if no king move will escape check

  iex> Board.kingImmobile(Board.startingPosition(), :orange)
  false

  iex> Board.kingImmobile(Board.kingImmobilePosition(), :orange)
  false

  iex> Board.kingImmobile(Board.kingImmobilePosition(), :blue)
  true

  """
  def kingImmobile(board, color) do
    king_loc = findKing(board, color)
    my_king_moves = possible_moves(board, king_loc, color)
    # no possible moves
    my_king_moves |> length() == 0

    # so there's generated possible moves, wh
  end

  @doc """
  Maps a function to each location on the placements of the board,
  This returns a new placements list.
  """
  def map_to_each(board, fun) do
    Enum.map(board, fn rank -> Enum.map(rank, fn tile -> fun.(tile) end) end)
  end

  @doc """
  Reduces a function to each location on the placements of the board, returns a list,
  with the function reduced onto each location.
  """
  def reduce_placements(board, acc, fun) do
    Enum.map(board, fn rank -> Enum.map(rank, fn tile -> fun.(tile, acc) end) end)
  end

  @doc """
  given a board and a color, returns true if there are no possible
  moves by pieces of that color that would resolve check
  (if you're not in check, this is not a useful fn :) )
  """
  def noMovesResolvingCheck(board, to_play) do

    threatened = threatens(board, otherColor(to_play))
    king_loc = findKing(board, to_play)
    king_moves = possible_moves(board, to_play, king_loc)
    # in the format [ {loc, placement} ...]
    all_friendly_pieces = fetch_locations(board, to_play)

    # we want to change the : list of {loc, placement} to : list of possible_moves,
    # then go through them, apply them onto the board,
    # and call isCheck on the new_board for to_play,
    # then, reduce the list of booleans to one result with Enum.all?()
    # so if one is not check, then there is a move resolving check, so false
    all_friendly_pieces
    |> Enum.map(fn
      {loc, {^to_play, _piece_type}} -> possible_moves(board, to_play, loc)
    end)
    |> Enum.map(fn
      {start_loc, {^to_play, piece_type,}, end_loc} ->
        move(start_loc, end_loc, to_play, piece_type, board.castling, board.promote, board.impale_loc)
    end)

    Enum.all?(king_moves, fn move -> Enum.member?(threatened, move) end)
  end

  def noPieceCanMove(placements, to_play) do
    ## TODO - FILL OUT SO IT WORKS WITH SPECIFIC COLOR
    ## WARNING GENERATED CODE

    placements
    |> fetch_locations()
    |> Enum.all?(fn rank -> Enum.all?(rank,
      fn tile -> immobile(placements, tile)
     end) end)
  end

  @doc """
  returns a list of all moves that a specific placement can make (a piece and color at a certain location)
  """
  def possible_moves(board, {_file, _rank} = location) do
    {piece_color, _pieceType} = _current_placement = get_at(board, location)

    possible_moves(board, location, piece_color)
  end

  def possible_moves(board, loc, playerColor) do
    #IO.puts("possible moves at #{inspect(loc)} and of color #{inspect(playerColor)}")
    {pieceColor, pieceType} = _current_placement = get_at(board, loc)

    if pieceColor != playerColor do
      :opponent_piece
      raise BoardError, message: "pieceColor #{inspect(pieceColor)} and piecetype #{pieceType} at #{inspect(loc)} are not #{playerColor}"
      # raise ArgumentError, message: "pieceColor does not match the piece at the location"
    else
      Moves.unappraised_moves(pieceColor, pieceType, loc)

      # TODO GOT SOME FILTERING TODO
      # filter out moves that do not get you out of check if you are in check

      # filter out castling when in check and when any of the spots the king will travel through are threatened by opponent

      # filter out impales (enpassant) when

      # add logic to filter out the moves blocked by a piece (opponent or friendly)

      # filter out moves that are not possible because they are a take in a move-only movetype

      # filter out moves are not possible because they are not a take in a take-only movetype

      # filter out moves that would place you in check (by moving to spots threatened by opponent)

      # filter out moves that would place you in check
      #(by unblocking an opponent's piece that now threatens your king)

    end
  end

  @doc """
  produces a nested approximation of the board_placements,
  with each location containing within it it's own location
  """
  def all_locations_nested(:dumb) do
    0..7 |> Enum.map(fn rank -> 0..7 |> Enum.map(fn file -> {rank, file} end) end)
  end

  def all_locations_nested(:formal) do
    8..1
    |> Enum.map(fn rank -> 1..8
    |> Enum.map(fn file -> {int_to_column(file), rank} end) end)
  end

  @doc """
  produces a list of all the locations on the board,
  in order from top left to bottom right
  """
  def all_locations_list(atom) when atom in [:dumb, :formal] do
    all_locations_nested(atom) |> List.flatten()
  end

  @doc """
  Looks in the board and returns a list of tuples of {location, placement}
  for every piece on the placements (including :mt)
  """
  def fetch_locations(board) do
    all_locations_list(:formal)
    |> Enum.map(fn loc -> {loc, get_at(board, Location.dumbLocation(loc))} end)
  end


  @doc """
  Looks in the board and returns a list of all the locations of the specified playerColor, or
  of the specified playerColor and pieceType
  in format List of tuples of {location, placement}
  where placement is
  """
  def fetch_locations(board, playerColor) do
    only_player_color_nested = board
    |> reduce_placements([],
    fn
      {^playerColor, type}, acc -> acc ++ [{playerColor, type}]
      {_otherColor, _type}, acc -> acc
      :mt, acc -> acc
      other, acc -> raise ArgumentError, message: "invalid tile #{inspect(other)} with acc #{inspect(acc)}"
    end)

    all_locations_list(:formal)
    |> Enum.map(fn loc -> {loc, get_at(only_player_color_nested, Location.dumbLocation(loc))} end)
    |> Enum.reject(fn
      {_loc, []} -> true
      {_loc, _any} -> false end)
    |> Enum.map(fn
      {loc, list} when list |> is_list() -> {loc, List.first(list)}
    end)
  end

  def fetch_locations(board, playerColor, pieceType) do
    only_color_and_piecetype_nested = board
    |> reduce_placements([], fn
      {^playerColor, ^pieceType}, acc -> acc ++ [{playerColor, pieceType}]
      {_otherColor, _type}, acc -> acc
      :mt, acc -> acc
      other, acc -> raise ArgumentError, message: "invalid tile #{inspect(other)} with acc #{inspect(acc)}"
    end)

    all_locations_list(:formal)
    |> Enum.map(fn loc -> {loc, get_at(only_color_and_piecetype_nested, Location.dumbLocation(loc))} end)
    |> Enum.reject(fn
      {_loc, []} -> true
      {_loc, _any} -> false end)
    |> Enum.map(fn {loc, list} when list |> is_list() -> {loc, List.first(list)}
    end)
  end


    # we want the raw moves assuming every possible move of a piece is valid, so for pawns, always sprinting, all directions of horse etc
    # moves_strategy(board, pieceColor, location, false, pawn_moves/2)
    # filter out impossible moves (off the board, or causes check, or is blocked by a piece, or is capturing a friendly piece)
    # |> Enum.filter(fn () ->  end)
    # convert each possible remaining move to a convenient move format (?) (ie {start, end} or {start, end, pieceType}) ?
    #|> Enum.map(fn () ->  end)

    def column_to_int(column) do
      case column do
        :a -> 1
        :b -> 2
        :c -> 3
        :d -> 4
        :e -> 5
        :f -> 6
        :g -> 7
        :h -> 8
      end
    end

    def int_to_column(num) do
      case num do
        1 -> :a
        2 -> :b
        3 -> :c
        4 -> :d
        5 -> :e
        6 -> :f
        7 -> :g
        8 -> :h
      end
    end

    @doc """
    returns whether there are any pieces standing between these two locations
    (that are not at those locations), returns false if the locations are not on
    the same rank, file, or diagonal
    """
  def blocked(board, {atomic_start_file, start_rank}, {atomic_end_file, end_rank}) do
    start_file = column_to_int(atomic_start_file)
    end_file = column_to_int(atomic_end_file)
      in_the_way = cond do
        start_rank == end_rank ->
          pieces_between(board, end_rank, {start_file, end_file})
        start_file == end_file ->
          pieces_between(board, {start_rank, end_rank}, end_file)
        on_diagonal?(start_file, start_rank, end_file, end_rank) ->
          pieces_between(board, {start_file, start_rank}, {end_file, end_rank})
        true ->
          :not_visible
          #raise ArgumentError, message: "hmm #{inspect(:not_visible)}"
      end
      [] != in_the_way
    end

  @doc """
  returns whether the two locations are on the same diagonal (uses math slope knowledge)
  """
  def on_diagonal?(x1, y1, x2, y2), do: y2 - y1 == x2 - x1 or y2 - y1 == x1 - x2

  #### GENERAL DIRECTION FUNCTIONS #### AND THEIR RECURSIVE HELPERS

  @doc """
  trawls the board and returns a list of all the pieces between the two locations,
  BUT the start and end locations do NOT count as pieces between
  """
  def up(board, y1, y2, x) do #5 7 1
    yn = y1 + 1
    case yn do
      ^y2 -> []
      _ -> recUp(board, yn, y2, x, [])
    end
  end

  def down(board, y1, y2, x) do # 7 5 1
    up(board, y2, y1, x) # 5 7 1
  end

  def recUp(board, start_rank, end_rank, x, acc) do
    # 6 7 1
    placement = get_at(board, {int_to_column(x), start_rank})

    new_acc = case placement do
      :mt -> acc
      {color, type} -> acc ++ [{{start_rank, x}, {color, type}}]
    end

    new_rank = start_rank + 1

    case new_rank do
      ^end_rank -> new_acc
      _ -> recUp(board, new_rank, end_rank, x, new_acc)
    end
  end

  def right(board, y, x1, x2) do
    xn = x1 + 1
    case xn do
      ^x2 -> []
      _ -> recRight(board, y, x1, x2, [])
    end
  end

  def left(board, y, x1, x2) do
    right(board, y, x2, x1)
  end

  def recRight(board, y, start_file, end_file, acc) do
    placement = get_at(board, {int_to_column(start_file), y})

    new_acc = case placement do
      :mt -> acc
      {color, type} -> acc ++ [{{y, start_file}, {color, type}}]
    end

    new_file = start_file + 1

    case new_file do
      ^end_file -> new_acc
      _ -> recRight(board, y, new_file, end_file, new_acc)
    end
  end

  def upRight(board, y1, x1, y2, x2) do
    xn = x1 + 1
    yn = y1 + 1
    case {xn, yn} do
      {^x2, ^y2} -> []
      _ -> recUpRight(board, y1, x1, y2, x2, [])
    end
  end

  def downLeft(board, y1, x1, y2, x2) do
    upRight(board, y2, x2, y1, x1)
  end

  def upLeft(board, y1, x1, y2, x2) do
    xn = x1 - 1
    yn = y1 + 1
    case {xn, yn} do
      {^x2, ^y2} -> []
      _ -> recUpLeft(board, y1, x1, y2, x2, [])
    end
  end

  def downRight(board, y1, x1, y2, x2) do
    upLeft(board, y2, x2, y1, x1)
  end

  def recUpLeft(board, start_rank, start_file, end_rank, end_file, acc) do
    placement = get_at(board, {int_to_column(start_file), start_rank})

    new_acc = case placement do
      :mt -> acc
      {color, type} -> acc ++ [{{int_to_column(start_file), start_rank}, {color, type}}]
    end

    new_file = start_file - 1
    new_rank = start_rank + 1

    case {new_file, new_rank} do
      {^end_file, ^end_rank} -> new_acc
      _ -> recUpLeft(board, new_rank, new_file, end_rank, end_file, new_acc)
    end
  end

  def recUpRight(board, start_rank, start_file, end_rank, end_file, acc) do
    placement = get_at(board, {int_to_column(start_file),start_rank})

    new_acc = case placement do
      :mt -> acc
      {color, type} -> acc ++ [{{int_to_column(start_file), start_rank}, {color, type}}]
    end

    new_file = start_file + 1
    new_rank = start_rank + 1

    case {new_file, new_rank} do
      {^end_file, ^end_rank} -> new_acc
      _ -> recUpRight(board, new_rank, new_file, end_rank, end_file, new_acc)
    end
  end

  @doc """
  returns a list of {location, placement} which represent pieces between the two locations
  """
  def pieces_between(board, {start_file, start_rank}, {end_file, end_rank}) do
    cond do # file = x, rank = y
      start_rank > end_rank and start_file < end_file -> # negative slope (down right)
        downRight(board, start_rank, start_file, end_rank, end_file)
      start_rank > end_rank and start_file > end_file -> # positive slope (down left)
        downLeft(board, start_rank, start_file, end_rank, end_file)
      start_rank < end_rank and start_file > end_file -> # positive slope (up left)
        upLeft(board, start_rank, start_file, end_rank, end_file)
      start_rank < end_rank and start_file < end_file -> # negative slope (up right)
        upRight(board, start_rank, start_file, end_rank, end_file)
      true -> "one_or_more_is_equal"
    end
  end

  def pieces_between(board, rank, {start_file, end_file}) do
    cond do # file = x, rank = y (same rank)
      start_file < end_file -> # head right
        right(board, rank, start_file, end_file)
      start_file > end_file -> # head left
        left(board, rank, start_file, end_file)
      true -> "file_also_equal"
    end
  end

  def pieces_between(board, {start_rank, end_rank}, file) do
    cond do # file = x, rank = y (same file)
      start_rank < end_rank -> # head up
        up(board, start_rank, end_rank, file)
      start_rank > end_rank -> # head down
        down(board, start_rank, end_rank, file)
      true -> "rank_also_equal"
    end
  end

  @doc """
  Produce a list of all locations that the color specifies threatens on the board
  I will need to reconcile whether or not this includes moves
  that are impossible because they would place the color king in check
  (unblocking a threat on the king). I think it should, because you can
  put an opposing king in check by blocking a threat on your own king.
  """
  def threatens(board, color) do
    placements = board.placements

    # TODO: go through each type of piece and check
    # what possible moves are, keep a MapSet of all
    # locations that are threatened

    # TODO: check to make sure fetch_locations(board, color)
    #                            is not more appropriate here
    list_of_location_placement_tuples = Board.fetch_locations(placements)
    # now we traverse it
    |> Enum.map(fn
      # the ^ symbol indicates it's pattern matching on existing color
      {{_col, _row} = loc, {^color, _p_type}} ->
          # piece color is as specified
          {loc, possible_moves(placements, loc, color)}
      {{_col, _row} = loc, {_other_color, _p_type}} ->
        # any other color than the one specified
        {loc, :opposing_piece}
      {{_col, _row} = loc, :mt} ->
        {loc, :mt}
      end)
      |> Enum.reject(fn
        {_, :opposing_piece} -> true
        {_, :mt} -> true
        _ -> false
      end)
      ## so above we have a list tuples:
      #     {starting_location, list_of_movetype_ending_location_tuples}
      #     which look like [{move_type, ending_location},..]
      #where plausible moves are moves that are not obviously ending up off the board
      # or requiring a specific starting position (like sprinting, enpassant, castling, etc)
      # now lets put that start_location in the actual tuple
      |> Enum.map(fn
        {start_loc, plausible_loc_list} ->
          Enum.map(plausible_loc_list, fn
            {move_type, end_loc} ->
              {move_type, start_loc, end_loc}
          end)
         end)
         |> List.flatten
         ## so we put the start_loc in every interior tuple, outer tuple gotten rid of
          # now we have a list of tuples in the form:
          #     {move_type, start_loc, end_loc}
      |> Enum.map(fn  {move_type, start_loc, end_loc} ->
        # at every plausible movetype with an end_location ...
      # if the move is blocked, then we don't want to include it
      # if the move is not blocked, then we want to include it
      block_bool = blocked(placements, start_loc, end_loc)

      cond do
        Moves.jumping(move_type) -> {move_type, start_loc, end_loc}
        block_bool -> :blocked
        not block_bool -> {move_type, start_loc, end_loc}
      end
      end)
      # remove the :blocked
      |> Enum.reject(fn
        :blocked -> true
        _ -> false
      end)
      # Now the above has a list of {move_type, start_loc, end_loc} tuples
      # we will remove the moves that are move_only (like sprinting, castling, etc)
      |> Enum.reject(fn
        {move_type, _start_loc, _end_loc} ->
          Moves.moveOnly(move_type)
        _ -> false
        end)
      ## Now we have all the logic we need, we'll get rid of the move_type to
      ## get a list of {start_loc, end_loc} tuples, PERFECT
      |> Enum.map(fn
        {_move_type, start_loc, end_loc} ->
          {start_loc, end_loc}
        end)

      list_of_location_placement_tuples
  end

  @doc """
  Goes through the board placements and finds the king of the color specified, returning it's location
  Always a tuple.
  """
  def findKing(board, color) do
    for rank <- board, tile <- rank do
      case tile do
        {pieceColor, pieceType} ->
          if pieceColor == color and pieceType == :king do
            {pieceColor, pieceType}
          else
            :not_king
          end
        :mt -> :mt
      end
    end
    |> Enum.zip(Board.all_locations_list(:formal))
    |> Enum.reject(fn
      {:not_king, _loc} -> true
      {:mt, _loc} -> true
      {{^color, :king}, _loc} -> false
      end)
    |> raiseErrorIfEmpty(color)
    |> Enum.map(fn
      {{^color, :king}, loc} -> loc
      end)
    |> Enum.reduce(fn x, acc -> {x,acc} end)
  end

  def raiseErrorIfEmpty(list, color) when length(list) == 0, do: raise BoardError, message: "there is no king of the specified color #{inspect(color)}"
  def raiseErrorIfEmpty(list, _), do: list

  @doc """
  given placements and a color of the playing player,
  returns whether the possible moves for every piece are zero,
  if one piece has a move for exampole, it returns false
  """
  def noMoves(board, to_play) do
    for rank <- board, tile <- rank do
      {pieceColor, pieceType} = tile
      if pieceColor == to_play do
        # interesting, but we need no moves possible for any piece, so all piecetypes
        if not Enum.empty?(possible_moves(board, pieceType, tile)) do
          false
        end
      end
    end
    true
  end

  @doc """
  Given a board placements, reduces it to a list, with no location data
  """
  def listify(board) do
    board
    |> Enum.reduce([], fn x, accum -> accum ++ Enum.reduce(x, [], fn item, acc -> acc ++ [item] end) end)
  end

  @doc """
  Given a board, a piecetype and a color,
  reduces it to a list of only the color and piecetypes specified
  """
  def grab(board, piecetype, color) do
    board
    |> listify()
    |> Enum.filter(fn
      _other -> false
      {^color, ^piecetype} -> true
    end)
  end

  @doc """
  Given a board, a piecetype and a color,
  reduces it to a list of only the piecetypes specified
  """
  def grab(board, piecetype) do
    board
    |> listify()
    |> Enum.filter(fn
      _other -> false
      {_col, ^piecetype} -> true
    end)
  end

  @doc """
  Given a board and a color,
  reduces it to a list of only the pieces of that color
  """
  def grabColor(board, color) do
    board
    |> listify()
    |> Enum.filter(fn
      _other -> false
      {^color, _piecetype} -> true
    end)
  end

  @doc """
  The types of ways to hit insufficient material, and therefore a draw, are
  if both sides have one of the following and no pawns on the board

  - a lone king
  - a king and 1 bishop
  - a king and 1 knight

  and then (becuase king (bishop or knight) vs king knight knight is not a draw)
  - a king and two knights versus a lone king
  """
  def isInsufficientMaterial(board) do
    cond do
      kingKnightKnight(board, :orange) and justKing(board, :blue) -> true
      kingKnightKnight(board, :blue) and justKing(board, :orange) -> true
      badMaterial(board, :orange) and badMaterial(board, :blue) -> true
      true -> false
    end
  end

  @doc """
  given a board and a color,
  returns whether that color only has the pieces, king and two knights
  """
  def kingKnightKnight(board, color) do
    knight = grab(board, color, :knight) |> length()
    king = grab(board, color, :king) |> length()
    total = grabColor(board, color) |> length()

    total == 3 and knight == 2 and king == 1
  end

  @doc """
  given a board and a color,
  returns whether that color only has a king
  """
  def justKing(board, color) do
    king = grab(board, color, :king) |> length()
    total = grabColor(board, color) |> length()

    total == 1 and king == 1
  end

  @doc """
  given a board and a color,
  returns whether that color has just a king or
  just a king and a minor piece (bishop or knight)
  """
  def badMaterial(board, color) do
    bishop = grab(board, color, :bishop) |> length()
    knight = grab(board, color, :knight) |> length()
    minor_pieces = bishop + knight
    king = grab(board, color, :king) |> length()
    total = grabColor(board, color) |> length()

    (total == 1 and king == 1) or (total == 2 and king == 1 and minor_pieces == 1)
  end

  def isDraw(board, to_play) do
    # TODO
    false
  end

  def isCheckmate(board, to_play) do
    # TODO
    false
  end

  def immobile(board, {pieceColor, pieceType}) do
    # TODO
    false
  end

  #########################################
  # CONVENIENCE FUNCTIONS
  #########################################

  @doc """
  creates a starting position, placing all tiles,
  then all starting pieces on the board
  """
  def startingPosition() do
    make2DList(8,8)
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
  Convenience function:
  Given one color, switch to the other color (orange to blue, blue to orange)
  """
  def otherColor(:blue), do: :orange
  def otherColor(:orange), do: :blue


  # these are the help for replace_at, deprecated
  def reversePlacements(board), do: board |> reverseColumns|> reverseRanks

  def reverseRanks(board), do: Enum.reverse(board)

  def reverseColumns(board), do: Enum.map(board, fn x -> Enum.reverse(x) end)



  #########################################
# TILE FUNCTIONS
  #########################################

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
  # a placement is an item of the form {formal_location, tileType}, Only one formal_location have a an assigned tileType
  def isReplacingTile([], _formal_location), do: false
  def isReplacingTile(tileary, new_location) do
    Enum.reduce(tileary, false, fn {_tileType, existing_location} = _placement, acc -> existing_location == new_location or acc end)
  end

end
