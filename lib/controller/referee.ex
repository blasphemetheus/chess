defmodule Referee do
  @moduledoc """
  Documentation for `Referee`.
  """

  @doc """
  given a move, return a boolean representing whether
  the move is valid or not
  """
  def validateMove(board, s_loc, e_loc, player_color, piece_type, promote \\ :nopromote) do
    {res, _thing} = Chessboard.move(board, s_loc, e_loc, player_color, piece_type, promote)

    case res do
      :ok -> true
      :error -> false
    end
  end
end
