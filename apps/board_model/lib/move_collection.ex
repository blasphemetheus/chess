defmodule MoveCollection do
  import Board

  def kingBlockedByOwnPieces() do
    startingPosition()
    |> move!({:d, 2}, {:d, 4}, :orange, :pawn)
    |> move!({:g, 8}, {:f, 6}, :blue, :knight)
    |> move!({:c, 2}, {:c, 4}, :orange, :pawn)
    |> move!({:e, 7}, {:e, 5}, :blue, :pawn)
    |> move!({:d, 4}, {:e, 5}, :orange, :pawn)
    |> move!({:f, 6}, {:g, 4}, :blue, :knight)
    |> move!({:d, 1}, {:f, 3}, :orange, :knight)
    |> move!({:b, 8}, {:c, 6}, :blue, :knight)
    |> move!({:c, 1}, {:f, 4}, :orange, :bishop)
    |> move!({:f, 8}, {:b, 4}, :blue, :bishop)
    |> move!({:b, 1}, {:d, 2}, :orange, :knight)
    |> move!({:d, 8}, {:e, 7}, :blue, :queen)
    |> move!({:a, 2}, {:a, 3}, :orange, :pawn)
    |> move!({:g, 4}, {:e, 5}, :blue, :knight)
  end

  def foolsmate() do
    startingPosition()
    |> move!({:f, 2}, {:f, 3}, :orange, :pawn)
    |> move!({:e, 7},{:e, 6}, :blue, :pawn)
    |> move!({:g, 2}, {:g, 4}, :orange, :pawn)
    |> move!({:d, 8}, {:h, 4}, :blue, :queen)
  end

  def revfoolsmate() do
    startingPosition()
    |> move!({:e, 2}, {:e, 4}, :orange, :pawn)
    |> move!({:f, 7},{:f, 6}, :blue, :pawn)
    |> move!({:d, 2}, {:d, 4}, :orange, :pawn)
    |> move!({:g, 7}, {:g, 5}, :blue, :pawn)
    |> move!({:d, 8}, {:h, 5}, :orange, :queen)
  end

  def dutchfoolsmate() do
    startingPosition()
    |> move!({:f, 2}, {:f, 3}, :orange, :pawn)
    |> move!({:f, 7}, {:f, 5}, :blue, :pawn)
    |> move!({:c, 1}, {:g, 5}, :orange, :bishop)
    |> move!({:h, 7}, {:h, 6}, :blue, :pawn)
    |> move!({:g, 5}, {:h, 4}, :orange, :bishop)
    |> move!({:g, 7}, {:g, 5}, :blue, :pawn)
    |> move!({:e, 2}, {:e, 4}, :orange, :pawn)
    |> move!({:g, 5}, {:h, 4}, :blue, :pawn)
    |> move!({:d, 1}, {:h, 5}, :orange, :bishop)
  end

  def grobsfoolsmate() do
    startingPosition()
    |> move!({:g, 2}, {:g, 4}, :orange, :pawn)
    |> move!({:e, 7}, {:e, 5}, :blue, :pawn)
    |> move!({:f, 2}, {:f, 4}, :orange, :pawn)
    |> move!({:d, 8}, {:h, 4}, :blue, :queen)
  end

  def scholarsmate() do
    startingPosition()
    |> move!({:e, 2}, {:e, 4}, :orange, :pawn)
    |> move!({:e, 7}, {:e, 5}, :blue, :pawn)
    |> move!({:f, 1}, {:c, 4}, :orange, :bishop)
    |> move!({:b, 8}, {:c, 6}, :blue, :knight)
    |> move!({:d, 1}, {:h, 5}, :orange, :queen)
    |> move!({:g, 8}, {:f, 6}, :blue, :knight)
    |> move!({:h, 5}, {:f, 7}, :orange, :queen)
  end

  def birdfoolsmate() do
    placements = startingPosition()
    |> move!({:f, 2}, {:f, 4}, :orange, :pawn)
    |> move!({:e, 7}, {:e, 5}, :blue, :pawn)
    |> move!({:f, 4}, {:e, 5}, :orange, :pawn)
    |> move!({:d, 7}, {:e, 6}, :blue, :pawn)
    |> move!({:e, 5}, {:d, 6}, :orange, :pawn)
    |> move!({:f, 8}, {:d, 6}, :blue, :bishop)
    |> move!({:b, 1}, {:c, 3}, :orange, :knight)
    |> move!({:d, 8}, {:h, 4}, :blue, :queen)
    |> move!({:g, 2}, {:g, 3}, :orange, :pawn)
    |> move!({:h, 4}, {:g, 3}, :blue, :queen)
    |> move!({:h, 2}, {:g, 3}, :orange, :pawn)
    |> move!({:d, 6}, {:g, 3}, :blue, :bishop)

    GameRunner.takeTurns(%GameRunner{board: placements})
  end

  def carokannsmotheredmate() do
    startingPosition()
    |> move!({:e, 2}, {:e, 4}, :orange, :pawn)
    |> move!({:c, 7}, {:c, 6}, :blue, :pawn)
    |> move!({:d, 2}, {:d, 4}, :orange, :pawn)
    |> move!({:d, 7}, {:d, 5}, :blue, :pawn)
    |> move!({:b, 1}, {:c, 3}, :orange, :knight)
    |> move!({:d, 5}, {:e, 4}, :blue, :pawn)
    |> move!({:c, 3}, {:e, 4},:orange, :knight)
    |> move!({:b, 8}, {:d, 7}, :blue, :knight)
    |> move!({:d, 1}, {:e, 2}, :orange, :queen)
    |> move!({:g, 8}, {:f, 6}, :blue, :knight)
    |> move!({:e, 4}, {:d, 6}, :orange, :knight)
  end

  def italiansmotheredmate() do
    italiangame()
    |> move!({:c, 6}, {:d, 4}, :blue, :knight)
    |> move!({:f, 3}, {:e, 5}, :orange, :knight)
    |> move!({:d, 8}, {:g, 5}, :blue, :queen)
    |> move!({:e, 5}, {:f, 7}, :orange, :knight)
    |> move!({:g, 5}, {:g, 2}, :blue, :queen)
    |> move!({:h, 1}, {:f, 1}, :orange, :rook)
    |> move!({:g, 2}, {:e, 4}, :blue, :queen)
    |> move!({:c, 4}, {:e, 2}, :orange, :bishop)
    |> move!({:d, 4}, {:f, 3}, :blue, :knight)
  end

  def myopeningcapture() do
    placements = startingPosition()
    |> move!({:d, 2}, {:d, 4}, :orange, :pawn)
    |> move!({:d, 7}, {:d, 5}, :blue, :pawn)
    |> move!({:b, 1}, {:c, 3}, :orange, :knight)
    |> move!({:c, 8}, {:f, 5}, :blue, :bishop)
    |> move!({:g, 1}, {:f, 3}, :orange, :knight)
    |> move!({:e, 7}, {:e, 6}, :blue, :pawn)
    |> move!({:c, 1}, {:f, 4}, :orange, :bishop)
    |> move!({:f, 8}, {:b, 4}, :blue, :bishop)
    |> move!({:e, 2}, {:e, 3}, :orange, :pawn)
    |> move!({:g, 8}, {:f, 6}, :blue, :knight)
    |> move!({:f, 1}, {:d, 3}, :orange, :bishop)
    |> move!({:b, 4}, {:c, 3}, :blue, :bishop)

    GameRunner.takeTurns(%GameRunner{board: placements})

  end

  def italiangame() do
    startingPosition()
    |> move!({:e, 2}, {:e, 4}, :orange, :pawn)
    |> move!({:e, 7}, {:e, 5}, :blue, :pawn)
    |> move!({:g, 1}, {:f, 3}, :orange, :knight)
    |> move!({:b, 8}, {:c, 6}, :blue, :knight)
    |> move!({:f, 1}, {:c, 4}, :orange, :bishop)
  end

  def owensfoolsmate() do
    startingPosition()
    |> move!({:e, 2}, {:e, 4}, :orange, :pawn)
    |> move!({:b, 7}, {:b, 6}, :blue, :pawn)
    |> move!({:d, 2}, {:d, 4}, :orange, :pawn)
    |> move!({:c, 8}, {:b, 7}, :blue, :bishop)
    |> move!({:f, 1}, {:d, 3}, :orange, :bishop)
    |> move!({:f, 7}, {:f, 5}, :blue, :pawn)
    |> move!({:e, 4}, {:f, 5}, :orange, :pawn)
    |> move!({:b, 7}, {:g, 2}, :blue, :bishop)
    |> move!({:d, 1}, {:h, 5}, :orange, :queen)
    |> move!({:g, 7}, {:g, 6}, :blue, :pawn)
    |> move!({:f, 5}, {:g, 6}, :orange, :pawn)
    |> move!({:g, 8}, {:f, 6}, :blue, :knight)
    |> move!({:g, 6}, {:h, 7}, :orange, :pawn)
    |> move!({:f, 6}, {:h, 5}, :blue, :knight)
    |> move!({:d, 3}, {:g, 6}, :orange, :bishop)
  end

  def englundgambitmate() do
    startingPosition()
    |> move!({:d, 2}, {:d, 4}, :orange, :pawn)
    |> move!({:d, 7}, {:d, 5}, :blue, :pawn)
    |> move!({:d, 4}, {:e, 5}, :orange, :pawn)
    |> move!({:d, 8}, {:e, 7}, :blue, :queen)
    |> move!({:g, 1}, {:f, 3}, :orange, :knight)
    |> move!({:b, 8}, {:c, 6}, :blue, :knight)
    |> move!({:c, 1}, {:f, 4}, :orange, :bishop)
    |> move!({:e, 7}, {:b, 4}, :blue, :queen)
    |> move!({:f, 4}, {:e, 2}, :orange, :bishop)
    |> move!({:b, 4}, {:b, 2}, :blue, :queen)
    |> move!({:e, 2}, {:c, 3}, :orange, :bishop)
    |> move!({:f, 8}, {:b, 4}, :blue, :bishop)
    |> move!({:d, 1}, {:d, 2}, :orange, :queen)
    |> move!({:b, 4}, {:c, 3}, :blue, :bishop)
    |> move!({:d, 2}, {:c, 3}, :orange, :queen)
    |> move!({:b, 2}, {:c, 1}, :blue, :queen)
  end

  def budapestsmotheredmate() do
    startingPosition()
    |> move!({:d, 2}, {:d, 4}, :orange, :pawn)
    |> move!({:g, 8}, {:f, 6}, :blue, :knight)
    |> move!({:c, 2}, {:c, 4}, :orange, :pawn)
    |> move!({:e, 7}, {:e, 5}, :blue, :pawn)
    |> move!({:d, 4}, {:e, 5}, :orange, :pawn)
    |> move!({:f, 6}, {:g, 4}, :blue, :knight)
    |> move!({:d, 1}, {:f, 3}, :orange, :knight)
    |> move!({:b, 8}, {:c, 6}, :blue, :knight)
    |> move!({:c, 1}, {:f, 4}, :orange, :bishop)
    |> move!({:f, 8}, {:b, 4}, :blue, :bishop)
    |> move!({:b, 1}, {:d, 2}, :orange, :knight)
    |> move!({:d, 8}, {:e, 7}, :blue, :queen)
    |> move!({:a, 2}, {:a, 3}, :orange, :pawn)
    |> move!({:g, 4}, {:e, 5}, :blue, :knight)
    |> move!({:a, 3}, {:b, 4}, :orange, :pawn)
    |> move!({:e, 6}, {:d, 3}, :blue, :knight)
  end

  def shorteststalemate() do
    startingPosition()
    |> move!({:c, 2}, {:c, 4}, :orange, :pawn)
    |> move!({:h, 7}, {:h, 5}, :blue, :pawn)
    |> move!({:h, 2}, {:h, 4}, :orange, :pawn)
    |> move!({:a, 7}, {:a, 5}, :blue, :pawn)
    |> move!({:d, 1}, {:a, 4}, :orange, :queen)
    |> move!({:a, 8}, {:a, 6}, :blue, :rook)
    |> move!({:a, 4}, {:a, 5}, :orange, :queen)
    |> move!({:a, 6}, {:h, 6}, :blue, :rook)
    |> move!({:a, 5}, {:c, 7}, :orange, :queen)
    |> move!({:f, 2}, {:f, 3}, :blue, :pawn)
    |> move!({:c, 7}, {:d, 7}, :orange, :queen)
    |> move!({:e, 8}, {:f, 7}, :blue, :king)
    |> move!({:d, 7}, {:b, 7}, :orange, :queen)
    |> move!({:d, 8}, {:d, 3}, :blue, :queen)
    |> move!({:b, 7}, {:b, 8}, :orange, :queen)
    |> move!({:d, 3}, {:h, 7}, :blue, :queen)
    |> move!({:b, 8}, {:c, 8}, :orange, :queen)
    |> move!({:f, 7}, {:g, 6}, :blue, :king)
    |> move!({:c, 8}, {:e, 6}, :orange, :queen)
  end

  def nocapturesstalemate() do
    startingPosition()
    |> move!({:d, 2}, {:d, 4}, :orange, :pawn)
    |> move!({:e, 7}, {:e, 5}, :blue, :pawn)
    |> move!({:d, 1}, {:d, 2}, :orange, :queen)
    |> move!({:e, 5}, {:e, 4}, :blue, :pawn)
    |> move!({:d, 2}, {:f, 4}, :orange, :queen)
    |> move!({:f, 7}, {:f, 5}, :blue, :pawn)
    |> move!({:h, 2}, {:h, 3}, :orange, :pawn)
    |> move!({:f, 8}, {:b, 4}, :blue, :bishop)
    |> move!({:b, 1}, {:d, 2}, :orange, :knight)
    |> move!({:d, 7}, {:d, 6}, :blue, :pawn)
    |> move!({:f, 4}, {:h, 2}, :orange, :queen)
    |> move!({:c, 8}, {:e, 6}, :blue, :bishop)
    |> move!({:a, 2}, {:a, 4}, :orange, :pawn)
    |> move!({:d, 8}, {:h, 4}, :blue, :queen)
    |> move!({:a, 1}, {:a, 3}, :orange, :rook)
    |> move!({:c, 7}, {:c, 5}, :blue, :pawn)
    |> move!({:a, 3}, {:g, 3}, :orange, :rook)
    |> move!({:f, 5}, {:f, 4}, :blue, :pawn)
    |> move!({:f, 2}, {:f, 3}, :orange, :pawn)
    |> move!({:e, 6}, {:b, 3}, :blue, :bishop)
    |> move!({:d, 4}, {:d, 5}, :orange, :pawn)
    |> move!({:b, 4}, {:a, 5}, :blue, :bishop)
    |> move!({:c, 2}, {:c, 4}, :orange, :pawn)
    |> move!({:e, 4}, {:e, 3}, :blue, :bishop)
  end
end
