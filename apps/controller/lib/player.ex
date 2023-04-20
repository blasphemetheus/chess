defmodule Player do
  defstruct type: :human, color: :orange, tag: "Player"

  def toggleControl(player) do
    case player.type do
      :cpu -> %Player{type: :human}
      :human -> %Player{type: :cpu}
      _ -> raise "Invalid player type"
    end
  end
end
