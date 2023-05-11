defmodule Genomeur.Scene.Ur do
  @moduledoc """
  The Scene where the game of Ur is played.
  Will include a Game and Board component specific to Ur.
  Maybe also an optional Tournament_Peek component if this is part of a tournament.
  And a Matchup_Peek component if part of a matchup.
  """

  use Scenic.Scene
  alias Scenic.Graph
  alias Genomeur.Component.Nav
  alias Genomeur.Component.Notes
  import Scenic.Primitives
  import Scenic.Components
  import Genomeur.Position

  @note """
  The Ur game has a long history, predating the roman game of backgammon.
  Some professor with great hair translated a tablet that gave clues at reconstructing the
  rules of the game. Presented here are those rules, plus whatever additions I feel make sense.
  """

  # should push notes to graph, look at examples
  # @notes """
  # \"Components\" shows the basic components available in Scenic.
  # Messages sent by the component are displayed live.
  # The crash button raises an error, demonstrating how recovery works.
  # """

  @graph Graph.build()
  # redundant sequence for my own amusement vvv
    |> Genomeur.Position.add_to_graph(:init_data, translate: {20, 20})
    |> position(:init_data, translate: {20, 60})
    |> text("Present Options:", font_size: 22, translate: {130, 88})
    |> dropdown({[
      {"Chromosome", :chromosome},
      {"Learning", :learning},
      {"Competition", :competition}
    ], :competition}, id: :dropdown_id, translate: {300, 60})
    |> text("Ur", font_size: 22, translate: {20, 88})
    |> button("Roll", translate: {20, 180})
    |> button("Bet", id: :bet_btn, translate: {60, 20})
    |> button("Resign", id: :resign_btn, translate: {400, 20}, theme: :warning)
    |> button("BACK", id: :back_btn, translate: {600, 20}, theme: :danger)
    |> checkbox({"colorBreakdown", false}, id: :color_breakdown, translate: {20, 400})
    |>  radio_group({[
      {"Tense", :radio_tense},
      {"Relax", :radio_relax},
      {"Jovial", :radio_jovial},
    ], :radio_relax}, id: :radio_mood, translate: {20, 300})
    |> text_field("Table Talk", id: :table_talk, translate: {600, 100})
    |> toggle(true, translate: {500, 88}, thumb_radius: 20)
    |> Nav.add_to_graph(__MODULE__)
    |> Notes.add_to_graph(@note)

  def init(scene, _param, _opts) do
    graph = @graph

    scene =
      scene
      |> assign(graph: graph, my_value: 123)
      |> push_graph(graph)

    {:ok, scene}
  end
end
