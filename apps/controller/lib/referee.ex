defmodule Referee do
  @moduledoc """
  Documentation for `Referee`.
  """

  @doc """
  given a move, return a boolean representing whether
  the move is valid or not
  """
  def validateMove(placements, s_loc, e_loc, player_color, piece_type, castling \\ :neither, promote \\ :nopromote, impale_loc \\ :noimpale) do
    {res, _thing} = Board.move(placements, s_loc, e_loc, player_color, piece_type, castling, promote, impale_loc)

    case res do
      :ok -> true
      :error -> false
    end
  end
end
