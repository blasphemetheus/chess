
defmodule UrBoard do
@moduledoc """
An implementation of an Ur Box and Board, complete with a drawer.
There are 3 by 8 UrTiles, of which 4 are out_of_play. There is a drawer as well.
And there are 8 tetrahedron dice with one active corner

Later might add support for a 3 x 12 board, but not right now
"""

import Board.Utils
## Module Attributes ##
@length 3
@width 8
@drawer_compartments 1
@pyramidal_dice 8
@counters 11
@sides [:orange, :blue] # order doesn't intrinsically come from the piece color, it's decided by the players
@square_type [:rosette, :water, :ice, :eyes, :plasma]
@starting_drawer :empty
@realms [:earth, :hell, :heaven]
@starting_limbo {11, 11}
@orange_home {0, 4}
@blue_home {2, 4}
@conventional_tiles [[:rosette, :eyes, :water, :eyes, :home, :end, :rosette, :plasma],
                     [:crystal, :water, :ice, :rosette, :water, :ice, :eyes, :water],
                     [:rosette, :eyes, :water, :eyes, :home, :end, :rosette, :plasma]]

# there should be the The Royal Game, Spartan Games and Finkel rule
# sets supported (three ways to play)

@doc """
Define %UrBoard{} struct.
"""
defstruct length: @length,
          width: @width,
          tiles: @conventional_tiles,
          placements: [],
          order: @sides,
          drawer: @starting_drawer,
          out_of_play: @starting_limbo

defguard onboard(w, l) when is_integer(w) and is_integer(l) and l <= 7 and l >= 0 and w <= 2 and w >= 0

@doc """
Creates a board, ready to play ur on
"""
def createBoard() do
  %UrBoard{
    placements: startingPosition()
  }
end

@doc """
Given placements (3 by 8) in the ur fashion and a line separator, print the
Ur Board to Command Line
"""
def printPlacements(urboard, line_sep \\ "\n") when is_struct(urboard) do
  printPlacements(urboard.placements)
end
def printPlacements(placements, line_sep) do
  placements
  |> Board.Utils.reverseRanks()
  #|> Enum.intersperse(:switch_tiles)
  |> Enum.map(fn
    x -> printRank(x, "\t ") <> line_sep
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
  |> Board.Utils.map_to_each(&translate/1)
  |> Enum.reduce("", fn x, accum -> accum <> Enum.reduce(x, "", fn item, acc -> acc <> item end) end)
end

@doc """
Creates a starting position, placing all chits on the board
"""
def startingPosition() do
  Board.Utils.make2DList(3, 8)
  |> placeMultipleOfPiece(:orange, :chit, 11, @orange_home)
  |> placeMultipleOfPiece(:blue, :chit, 11, @blue_home)
end

@doc """
insert a piece into the placements list of lists given a location ie (0, 0)
ase well as piececolor, piecetype and number of pieces to place

It should be noted that for ur, there can be multiple pieces at a location, but there
usually isn't
"""
def placeMultipleOfPiece(two_d_list, piece_color, piece_type, number_o_piece, {row, col} = loc) when is_integer(number_o_piece) do
  old_col = two_d_list |> Enum.at(row)
  old_rank = Enum.at(old_col, row)
  new_rank = case old_rank do
     o when is_list(o) -> o ++ for x <- 1..number_o_piece, do: {piece_color, piece_type}
     :mt -> for x <- 0..number_o_piece, do: {piece_color, piece_type}
  end
  new_col = List.replace_at(old_col, row, new_rank)

  List.replace_at(two_d_list, col, new_col)
end

@doc"""
Given a position, return the atom representing the square type at that posn
"""
def square_type(w, l) when onboard(w, l) do
  case w do
    1 -> case l do
      0 -> :crystal
      1 -> :water
      2 -> :ice
      3 -> :rosette
      4 -> :water
      5 -> :ice
      6 -> :eyes
      7 -> :water
    end
    _ -> case l do
      0 -> :rosette
      1 -> :eyes
      2 -> :water
      3 -> :eyes
      4 -> :home
      5 -> :end
      6 -> :rosette
      7 -> :plasma
    end
  end
end

@doc """
Given an w and l coordinate (raw), returns whether the posn is in heaven (the top side of the board, the head).
"""
def in_heaven(w, l) when onboard(w, l) do
  l == 6 or l == 7
end


@doc """
Given an w and l coord (raw), returns whether the posn is in hell (the bridge, or the neck)
"""
def in_hell(w, l) when onboard(w, l) do
  w == 1 and (l == 4 or l == 5)
end


@doc """
Given an w and l coord (raw), returns whether the posn is in limbo (the start and end squares, not on board).
"""
def in_limbo(w, l) when onboard(w, l) do
  w != 1 and (l == 4 or l == 5)
end


@doc """
Given an w and l coord (raw), returns whether the posn is on earth (the main stretch).
"""
def on_earth(w, l) when onboard(w, l) do
  l < 4
end


@doc """
Given an w and l coord (raw), returns whether the posn is on the upside (topside, goes first usually)
"""
def upside(w, l) when onboard(w, l) do
  w == 0
end


@doc """
Given an w and l coord (raw) returns whether the posn is on the downside (bottom, goes second usually, underworld)
"""
def downside(w, l) when onboard(w, l) do
  w == 2
end

end
