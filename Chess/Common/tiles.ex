# function for rendering tiles graphically
# (empty of blue, empty of orange, containing a pawn, a bishop, knight, rook, queen, knight of each color).
# fn may map a board location representation to ascii, graphical images, decorations, etc
def renderTile(:orange, piece) do
  case piece do
    :empty -> "◻"
    :king -> "♔"
    :queen -> "♕"
    :rook -> "♖"
    :bishop -> "♗"
    :knight -> "♘"
    :pawn -> "♙"
    _ -> raise ArgumentError, message: "invalid piecetype: " <> piece
  end
end

def renderTile(:blue, piece) do
  case piece do
    :empty -> "◼"
    :king -> "♚"
    :queen -> "♛"
    :rook -> "♜"
    :bishop -> "♝"
    :knight -> "♞"
    :pawn -> "♟︎"
    _ ->  raise ArgumentError, message: "invalid piecetype: " <> piece
  end
end

def renderTile(color, _) do
  raise ArgumentError, message: "invalid color: " <> color
end


assert renderTile(:orange, :empty) == "◻"
assert renderTile(:blue, :empty) == "◼"

assert renderTile(:orange, :king) == "♔"
assert renderTile(:blue, :king) == "♚"

assert renderTile(:orange, :queen) == "♕"
assert renderTile(:blue, :queen) == "♛"

assert renderTile(:orange, :rook) == "♖"
assert renderTile(:blue, :rook) == "♜"

assert renderTile(:orange, :bishop) == "♗"
assert renderTile(:blue, :bishop) == "♝"

assert renderTile(:orange, :knight) == "♘"
assert renderTile(:blue, :knight) == "♞"

assert renderTile(:orange, :pawn) == "♙"
assert renderTile(:blue, :pawn) == "♟︎"

assert renderTile(red, :pawn) == ArgumentError
assert renderTile(:red, :queen) == ArgumentError
assert renderTile(orange, :king) == ArgumentError
assert renderTile(:orange, bishop) == ArgumentError
assert renderTile(:orange, :unicorn) == ArgumentError
assert renderTile(:blue, :unicorn) == ArgumentError
assert renderTile(:blue, king) == ArgumentError
assert renderTile() == ArgumentError

#TileColors can be orange or blue, but this will be expanded.
#PieceColors can be orange or blue, but this will be expanded.


# There are only 2 + 6 + 6 (so 14 difference possible tile states for graphics purposes)

# function that computes data representations of the 14 unique configurations (with room for more!)
def externalTileRep(tileColor) do
  assignExtTileColor(tileColor)
  externalTileColor = case tileColor do
    :blue -> "blue"
    :orange -> "orange"
    _ -> raise ArgumentError("invalid tileColor: " <> tileColor)
  end

  "{\"tileColor\":" <> assignExtTileColor(tileColor) <> ",\"contains\":[]}"
end

defp assignExtTileColor(tileColor) do
  case tileColor do
    :blue -> "blue"
    :orange -> "orange"
    _ -> raise ArgumentError("invalid tileColor: " <> tileColor)
  end
end

def externalTileRep(tileColor, pieceColor, pieceType) do
  tc = assignExtTileColor(tileColor)
  pc = assignExtPieceColor(pieceColor)
  pt = assignExtPieceType(pieceType)

  "{\"tileColor\":" <> tc <> ",\"contains\":[" <> pc <> ", " <> pt <> "]}"
end

assert externalTileRep(:blue) == "{\"tilecolor\":\"blue\",\"contains\":[]}"
assert externalTileRep(:orange) == "{\"tilecolor\":\"orange\",\"contains\":[]}"

assert externalTileRep(:blue, :orange, :pawn) == "{\"tilecolor\":\"blue\",\"contains\":[\"orange\", \"pawn\"]}"
assert externalTileRep(:blue, :orange, :rook) == "{\"tilecolor\":\"blue\",\"contains\":[\"orange\", \"rook\"]}"
assert externalTileRep(:blue, :orange, :king) == "{\"tilecolor\":\"blue\",\"contains\":[\"orange\", \"king\"]}"
assert externalTileRep(:blue, :orange, :bishop) == "{\"tilecolor\":\"blue\",\"contains\":[\"orange\", \"bishop\"]}"
assert externalTileRep(:blue, :orange, :knight) == "{\"tilecolor\":\"blue\",\"contains\":[\"orange\", \"knight\"]}"
assert externalTileRep(:blue, :orange, :queen) == "{\"tilecolor\":\"blue\",\"contains\":[\"orange\", \"queen\"]}"

assert externalTileRep(:blue, :blue, :pawn) == "{\"tilecolor\":\"blue\",\"contains\":[\"blue\", \"pawn\"]}"
assert externalTileRep(:blue, :blue, :rook) == "{\"tilecolor\":\"blue\",\"contains\":[\"blue\", \"rook\"]}"
assert externalTileRep(:blue, :blue, :king) == "{\"tilecolor\":\"blue\",\"contains\":[\"blue\", \"king\"]}"
assert externalTileRep(:blue, :blue, :bishop) == "{\"tilecolor\":\"blue\",\"contains\":[\"blue\", \"bishop\"]}"
assert externalTileRep(:blue, :blue, :knight) == "{\"tilecolor\":\"blue\",\"contains\":[\"blue\", \"knight\"]}"
assert externalTileRep(:blue, :blue, :queen) == "{\"tilecolor\":\"blue\",\"contains\":[\"blue\", \"queen\"]}"

assert externalTileRep(:orange, :blue, :pawn) == "{\"tilecolor\":\"orange\",\"contains\":[\"blue\", \"pawn\"]}"
assert externalTileRep(:orange, :orange, :king) == "{\"tilecolor\":\"orange\",\"contains\":[\"orange\", \"king\"]}"
assert externalTileRep(:orange, :orange, :rook) == "{\"tilecolor\":\"orange\",\"contains\":[\"orange\", \"rook\"]}"
assert externalTileRep(:orange, :orange, :bishop) == "{\"tilecolor\":\"orange\",\"contains\":[\"orange\", \"bishop\"]}"
assert externalTileRep(:orange, :orange, :knight) == "{\"tilecolor\":\"orange\",\"contains\":[\"orange\", \"knight\"]}"
assert externalTileRep(:orange, :orange, :queen) == "{\"tilecolor\":\"orange\",\"contains\":[\"orange\", \"queen\"]}"
assert externalTileRep(:orange, :orange, :pawn) == "{\"tilecolor\":\"orange\",\"contains\":[\"orange\", \"pawn\"]}"
