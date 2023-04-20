defmodule Board.Utils do
  import Board
  import Location
  @moduledoc """
  These are throwaway utility functions that belong in Board.
  Keeping them here because board.ex is too big. Submodule yafeel
  Some are made during initial fn writing, some in repl shenanigans
  """

  def nested_convert_to_formal(nested_dumb_placements) do
    nested_dumb_placements |> Board.map_to_each(&(&1 |> Location.formalLocation()))
  end

  @doc """
  How I'm transporting constants across modules
  iex> Board.Utils.get_constant(:pawn_moves, Move)
  [1, 2]
  """
  def get_constant(constant_atom, module) do
    [const] = module.__info__(:attributes)[constant_atom]
    const
  end
end
