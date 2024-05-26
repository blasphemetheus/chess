
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
  inspect(urboard, label: "urboard")
  printPlacements(urboard.placements, urboard.tiles, line_sep)
end
def printPlacements(placements, tiles, line_sep) do
  inspect(placements, label: "placements")
  inspect(tiles, label: "tiles")

  tiles
  # zip twice (ranks then placements)
  |> Enum.zip_with(placements,
  fn (tile_rank, place_rank) ->
    Enum.zip_with(tile_rank, place_rank,
    fn
      tile, placement -> {tile, placement}
   end)
  end
  )
  |> Board.Utils.map_to_each(&translate_ur/1)
  |> Enum.reduce("", fn x, accum -> accum <> Enum.reduce(x, "", fn item, acc -> acc <> item end) end)



  # Enum.intersperse(tiles, placements)
  # |> Enum.chunk_every(2)
  # |> Enum.map(fn [tile, placement] -> {tile, placement} end)
  # # |> Board.Utils.reverseRanks()
  # #|> Enum.intersperse(:switch_tiles)
  # |> Enum.map(fn
  #   x -> printRank(:ur, x, "\t ") <> line_sep
  #   end) |> to_string() |> inspect()

  #Enum.intersperse()
  # Tile.renderTile(:blue)
  # Tile.renderTile(:orange)

  # we need nested tile colors to zip into the board
  # Tile.nestedTileColors()
  # # so we must zip TWICE (zip ranks, zip placements)
  # |> Enum.zip_with(placements,
  #   fn (tile_color_rank, board_rank) ->
  #     Enum.zip_with(tile_color_rank, board_rank, fn
  #       tile_color, :mt -> tile_color
  #       _tile_color, not_empty -> not_empty
  #       end)
  #     end)
  # ## |> Enum.map(fn x -> Enum.chunk_every(x, 2) |> List.to_tuple() end)
  # |> Board.Utils.map_to_each(&translate_ur/1)
  # |> Enum.reduce("", fn x, accum -> accum <> Enum.reduce(x, "", fn item, acc -> acc <> item end) end)
end

###### UR Game Rules ####### move to Ur model or ur_game.ex or smth
# this function should be in random utils or whatever
@doc """
Roll
"""
def roll_pyramids_sum(amount) do
  # a corner can be :blank or :marked
  roll_pyramids_list(amount)
  |> Enum.sum()
end

@doc """
Given an amount of tetrahedrons (3D pyramids) to roll, return a list of values (from 0 to 1) that were rolled
"""
def roll_pyramids_list(amount) do
  # a corner can be :blank or :marked
  1..amount
  |> Enum.map(&roll_tetrahedron/0)
end

@doc """
Roll one tetrahedron with default reandomness approximately, returning a 0 for unmarked and 1 for marked
"""
def roll_tetrahedron() do
  upside = Enum.random([:blank, :blank, :marked, :marked])
  case upside do
    :blank -> 0
    :marked -> 1
  end
end


@doc """
Given an urboard (doesn't matter whose turn) and returns whether the position is final
"""
def isOver(urboard) do
  # over when 7 pieces make it to a home space
  scored_seven(urboard.placements, :orange) or scored_seven(urboard.placements, :blue)
end

@doc """
Given placements and  color, returns whether that color has seven in their end square
"""
def scored_seven(placements, color) do
  placements
  |> Enum.at(0)
  |> Enum.at(5)
  |> is_it_seven_chits_of_color(color)
end

def is_it_seven_chits_of_color(alist, color) when is_list(alist) and is_atom(color) do
    length(alist) == 7 and Enum.all?(fn
      {color, :chit} -> true
      {_color, _any} -> false
  end)
end

def is_it_seven_chits_of_color(alist, color) do
  false
end

@doc """
Creates a starting position, placing all chits on the board
"""
def startingPosition() do
  Board.Utils.make2DList(8, 3)
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
