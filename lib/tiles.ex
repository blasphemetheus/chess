defmodule Tile do
  @moduledoc """
  Tile Docs, this is the tile stuff
  """

  @doc """
  function for rendering tiles graphically
  (empty of blue, empty of orange, containing a pawn, a bishop, knight, rook, queen, knight of each color).
  fn may map a board location representation to ascii, graphical images, decorations, etc
  #TileColors can be orange or blue, but this will be expanded.
  #PieceColors can be orange or blue, but this will be expanded.
  # There are only 2 + 6 + 6 (so 14 difference possible tile states for graphics purposes)
  """
  def renderTile(:orange, piece) do
    case piece do
      :empty -> "◻"
      :king -> "♔"
      :queen -> "♕"
      :rook -> "♖"
      :bishop -> "♗"
      :knight -> "♘"
      :pawn -> "♙"
      _ -> raise ArgumentError, message: "invalid piecetype"
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
      _ ->  raise ArgumentError, message: "invalid piecetype"
    end
  end

  def renderTile(color, _) do
    raise ArgumentError, message: "invalid color"
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
end
