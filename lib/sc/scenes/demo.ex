defmodule Genomeur.Scene.Demo do
  @moduledoc """
  This is where the Demo scene is put togother, will have cpus playing all the
  supported events, first chess.
  """
  use Scenic.Scene
  alias Scenic.Graph
  import Scenic.Primitives
  import Scenic.Components
  import Scenic.PubSub

  alias Genomeur.Component.Nav
  alias Genomeur.Component.Notes
  alias Genomeur.PubSub.ChessComputers
  alias Scenic.PubSub

  @body_offset 80
  @font_size 60

  @pubsub_data {Scenic.PubSub, :data}
  @pubsub_registered {Scenic.PubSub, :registered}

  @notes """
  \"Demo\" Endeavors to show off the current state of the
  various games supported by genomeur by playing them in real time
  and presenting them as various simulated sensors. Or something similar.
  """

  @impl Scenic.Scene
  def init(scene, _param, _opts) do
    Scenic.PubSub.subscribe(:chess_computers)
    # align buttons and chesscomputers display in runtime
    {width, _} = scene.viewport.size
    col = width / 6

    # build graph
    graph =
      Graph.build(font: :roboto, font_size: 16)
        |> text("chesscomputers", id: :text_chess_board, text_align: :center, font: :chess_font, font_size: @font_size, translate: {width / 2, 300})
        |> add_specs_to_graph([text_spec("Unhandled EVENT TEXT", id: :event_text, t: {0, 800})])
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

    scene =
      scene
      |> assign(:graph, graph)
      |> push_graph(graph)

    {:ok, scene}
  end

  def makePretty(chess_board_string) do
    chess_board_string
    |> String.graphemes()
    |> Enum.map(&(&1 |> transform_to_chess_font()))
    |> Enum.chunk_every(8)
    |> Enum.map(&(&1 ++ ["\n"]))
    |> Enum.map(&(&1 |> List.to_string))
    |> List.to_string()
  end

  def transform_to_chess_font(string_of_piece) do
    case string_of_piece do
      "♚" -> "l"
      "♔" -> "k"
      "♛" -> "w"
      "♕" -> "q"
      "♜" -> "t"
      "♖" -> "r"
      "♝" -> "n"
      "♗" -> "b"
      "♞" -> "j"
      "♘" -> "h"
      "♟︎" -> "o"
      "♙" -> "p"
      "☻" -> ""
      "☺" -> ""
      "◼" -> "+"
      "◻" -> "_"
    end
  end

  @impl GenServer
  def handle_info({@pubsub_data, {:chess_computers, game_runner, id}}, %{assigns: %{graph: graph}} = scene) do
    # take given board and convert into scenic viewable board
    visual = game_runner.board.placements |> Chessboard.printPlacements() |> makePretty()

    # IO.puts("GR:: #{inspect(game_runner)} and id: #{inspect(id)}")
    # center chesscomputers on viewport
    graph = Graph.modify(graph, :text_chess_board, &text(&1, visual))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:noreply, scene}
  end

  def handle_info({@pubsub_registered, _something}, scene) do
    {:noreply, scene}
  end

  # any event update event_text
  def handle_event(event, _, %{assigns: %{graph: graph}} = scene) do
    graph = Graph.modify(graph, :event_text, &text(&1, (Enum.random(0..200) |> Integer.to_string()) <> "#{inspect(event)}"))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:noreply, scene}
  end

    @doc """
  Given info from chesscomputers' pubsub, have an effect be put into affect
  """
  @impl true
  def handle_info({{Scenic.PubSub, :data}, {:chess_computers, gr, id}}, %{assigns: %{graph: graph}} = sc) do
    IO.puts("Gamerunner:: #{inspect(gr)} and id: #{inspect(id)}")
    IO.puts("")

    # NO CHANGE TO GRAPH

    # graph = Graph.modify(graph, :all_pieces, &update_child(&1, :test, "changed", [{:stroke, {@stroke, :black}}]))
    scene =
      sc
      |> assign(graph: graph)
      |> push_graph(graph)

    {:noreply, scene}
  end

  def handle_info({{Scenic.PubSub, :registered}, {:chess_computers,
  [registered_at: registed_at_time_stamp, version: version,
  description: description]}}, scene) do
    IO.puts("REGISTERED")
    IO.puts("Registered at Timestamp: #{inspect(registed_at_time_stamp)}")
    IO.puts("Version Regged: #{inspect(version)}")
    IO.puts("Description: #{inspect(description)}")
    IO.puts("Scene: #{inspect(scene) |> String.slice(0..50) }")

    {:noreply, scene}
  end

  @spec handle_info({{Scenic.PubSub, :data}, any}) :: {:halt, any}
  def handle_info({{Scenic.PubSub, :data}, thing}) do
     IO.puts("Catchall GameRunner: #{inspect(thing)}")
     {:halt, thing}
   end
end
