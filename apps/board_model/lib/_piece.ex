defmodule Pawn do
  defstruct has_moved: false

end

defmodule Piece do
  @possible_types [:pawn, :bishop, :knight, :rook, :queen, :king]

  defstruct type: %Pawn{has_moved: true}, color: :orange

  def threatenBehavior() do

  end

  @attribute :cool
  def moveBehavior() do

  end
end
