defmodule Genomeur.Scene.Welcome do
  @moduledoc """
  This is the Welcome Scene, provides options to switch views,
  switch events, switch contexts (game, matchup, tourney) and provide your tag. Also
  playtype (so human vs cpu or whatever) on another scene.
  """
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Genomeur.Component.Nav
  alias Genomeur.Component.Notes

  import Scenic.Primitives
  import Scenic.Components

  @note """
  Welcome!
  """

  @text_size 24

  @first_col_x 20
  @second_col_x 160
  @third_col_x 450
  # --------------------------------------------------------
  def init(scene, _param, _opts) do
    # get the width and height of the viewport. This is to demonstrate creating
    # a transparent full-screen rectangle to catch user input
    {width, height} = scene.viewport.size

    # show the version of scenic and the glfw driver
    # scenic_ver = Application.spec(:scenic, :vsn) |> to_string()
    # driver_ver = Application.spec(:scenic_driver_local, :vsn) |> to_string()
    # elixir_ver = Application.spec(:elixir, :vsn) |> to_string()

    # info = "scenic: v#{scenic_ver}\nscenic_driver_local: v#{driver_ver}\nelixir: v#{elixir_ver}\n}"

    graph =
      Graph.build(font: :roboto, font_size: @text_size)
      # |> add_specs_to_graph([
      #   text_spec(info, translate: {600, 88}),
      #   text_spec(@note, translate: {600, 250}),
      #   rect_spec({width, height})
      # ])
      |> text("Player tag:", translate: {@first_col_x, 100})
      |> text("Rival Tag:", translate: {@first_col_x, 140})

      |> text("Play Type:", translate: {@first_col_x, 180})
      |> text("CPU Level:", translate: {@first_col_x, 220})
      |> text("Context:", translate: {@first_col_x, 260})

      |> text("Amount Players:", translate: {@first_col_x, 300})
      |> text("Games Per Match:", translate: {@first_col_x, 340})
      |> text_field("Leaf", id: :player_tag, translate: {@second_col_x, 100 - 20})
      |> text_field("Zoro", id: :opp_tag, translate: {@second_col_x, 140 - 20})

      |> dropdown({[
        {"Game", :game},
        {"Matchup", :matchup},
        {"Tournament", :tournament}
      ], :game}, id: :context_dropdown, translate: {@second_col_x, 260 - 28})
      |> dropdown({[
        {"0", :zero},
        {"1", :one},
        {"2", :two}
      ], :one}, id: :cpulevel_dropdown, translate: {@second_col_x, 220 - 28})
      |> dropdown({[
        {"Versus", :vs},
        {"Computer", :cpu},
        {"Online", :online}
      ], :cpu}, id: :playtype_dropdown, translate: {@second_col_x, 180 - 28})
      # |> text_field("Table Talk", id: :table_talk, translate: {600, 100})
      # |> dropdown({[
      #   {"Chromosome", :chromosome},
      #   {"Learning", :learning},
      #   {"Competition", :competition}
      # ], :competition}, id: :dropdown_id, translate: {300, 60})
      |> Nav.add_to_graph(__MODULE__)
      |> Notes.add_to_graph(@note)

    scene = push_graph(scene, graph)

    {:ok, scene}
  end

  def handle_input(event, _context, scene) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, scene}
  end
end
