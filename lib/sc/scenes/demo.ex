defmodule Gchess.Scenes.Demo do
  @moduledoc """
  This is where the Demo scene is put togother, will have cpus playing all the
  supported events, first chess.
  """
  use Scenic.Scene
  alias Scenic.Graph
  import Scenic.Primitives
  import Scenic.Components

  alias Genomeur.Component.Nav
  alias Genomeur.Component.Notes
  alias Scenic.PubSub

  @body_offset 80
  @font_size 160

  @pubsub_data {PubSub, :data}
  @pubsub_registered {PubSub, :registered}

  @notes """
  \"Demo\" Endeavors to show off the current state of the
  various games supported by genomeur by playing them in real time
  and presenting them as various simulated sensors. Or something similar.
  """

  @impl Scenic.Scene
  def init(scene, _param, _opts) do
    # align buttons and chesscomputers display in runtime
    {width, _} = scene.viewport.size
    col = width / 6

    # build graph
    graph =
      Graph.build(font: :roboto, font_size: 16)
        |> text("chesscomputers", id: :chesscomputers, text_align: :center, font_size: @font_size, translate: {width / 2, @font_size})
        |> group(fn g ->
          g
          |> button("Start", width: col * 4, height: 46, theme: :primary)
          |> button("Stop", width: col * 2 - 6, height: 46, theme: :secondary, translate: {0, 60})
          |> button("lvlUp", width: col * 2 - 6, height: 46, theme: :secondary, translate: {col * 2 + 6, 60})
        end,
        translate: {col, @font_size + 60},
        button_font_size: 24
        )
      # navdrop, notes added last so they are visible on top
      |> Nav.add_to_graph(__MODULE__)
      |> Notes.add_to_graph(@notes)

    Scenic.PubSub.subscribe(:chess_computers)

    scene =
      scene
      |> assign(:graph, graph)
      |> push_graph(graph)

    {:ok, scene}
  end

  @impl GenServer
  def handle_info({@pubsub_data, {:chess_computers, board, _something}}, %{assigns: %{graph: graph}} = scene) do
    # take given board and convert into scenic viewable board
    visual = board |> Board.printPlacements()

    # center chesscomputers on viewport
    graph = Graph.modify(graph, :chess_computers, &text(&1, visual))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:noreply, scene}
  end

  def handle_info({@pubsub_registered, _something}, scene) do
    {:noreply, scene}
  end
end
