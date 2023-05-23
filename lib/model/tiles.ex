defmodule Tile do
  @moduledoc """
  Tile Docs, this is the tile stuff
  """
  require TileError

  @doc """
  function for rendering tiles graphically
  (empty of blue, empty of orange, containing a pawn, a bishop, knight, rook, queen, knight of each color).
  fn may map a board location representation to ascii, graphical images, decorations, etc
  #TileColors can be orange or blue, but this will be expanded.
  #PieceColors can be orange or blue, but this will be expanded.
  # There are only 2 + 6 + 6 (so 14 difference possible tile states for graphics purposes)
  """
  def renderTile(:blue, piece) when is_atom(piece) do
    case piece do
      :mt -> "◻"
      :king -> "♔"
      :queen -> "♕"
      :rook -> "♖"
      :bishop -> "♗"
      :knight -> "♘"
      :pawn -> "♙"
      _ -> raise ArgumentError, message: "invalid piecetype"
    end
  end

  def renderTile(:orange, piece) when is_atom(piece) do
    case piece do
      :mt -> "◼"
      :king -> "♚"
      :queen -> "♛"
      :rook -> "♜"
      :bishop -> "♝"
      :knight -> "♞"
      :pawn -> "♟︎"
      _ ->  raise ArgumentError, message: "invalid piecetype"
    end
  end

  def renderTile(color, piece) do
    raise ArgumentError, message: "invalid render tile color, got #{inspect color} and #{inspect piece}"
  end


  def renderTile(tileColor) do
    case tileColor do
      :blue -> "◻"
      :orange -> "◼"
    end
  end

  @doc """
  function that computes data representations of the 14 unique configurations (with room for more!)
  """
  def externalTileRep(tileColor) do
    "{\"tileColor\":\"" <> assignExtTileColor(tileColor) <> "\",\"contains\":[]}"
  end

  defp assignExtTileColor(tileColor) do
    case tileColor do
      :blue -> "blue"
      :orange -> "orange"
      _ -> raise ArgumentError, message: "invalid tileColor: " <> tileColor
    end
  end

  defp assignExtPieceColor(pieceColor) do
    case pieceColor do
      :blue -> "blue"
      :orange -> "orange"
      _ -> raise ArgumentError, message: "invalid pieceColor: " <> pieceColor
    end
  end

  defp assignExtPieceType(pieceType) do
    case pieceType do
      :pawn -> "pawn"
      :bishop -> "bishop"
      :knight -> "knight"
      :rook -> "rook"
      :queen -> "queen"
      :king -> "king"
      _ -> raise ArgumentError, message: "invalid pieceType: " <> pieceType
    end
  end

  def externalTileRep(tileColor, pieceColor, pieceType) do
    tc = assignExtTileColor(tileColor)
    pc = assignExtPieceColor(pieceColor)
    pt = assignExtPieceType(pieceType)

    "{\"tileColor\":\"" <> tc <> "\",\"contains\":[\"" <> pc <> "\", \"" <> pt <> "\"]}"
  end

  def nestedTileColors do
    ## same as all_locations_nested(:formal) in Board
    8..1
    |> Enum.map(fn rank -> 1..8
    |> Enum.map(fn file -> {Board.int_to_column(file), rank} |> Tile.loc_to_color() end) end)
    ## NOW ON TO OTHER STUFF
  end


  @doc """
  Given a formal location, returns either :blue or :orange, representing what color tile should be there
  """
  def loc_to_color({file, rank}) do
    file_num = file |> Board.column_to_int()
    case rem(file_num + rank, 2) do
      0 -> :blue #even
      1 -> :orange #odd
    end
  end
end
