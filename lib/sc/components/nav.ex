defmodule Genomeur.Component.Nav do
  @moduledoc """
  This is where the Nav Component is.
  """
  use Scenic.Component

  alias Scenic.ViewPort
  alias Scenic.Graph

  import Scenic.Primitives, only: [{:text, 3}, {:rect, 3}]
  import Scenic.Components, only: [{:dropdown, 3}, {:toggle, 3}]

  @height 60

  @impl Scenic.Component
  def validate(scene) when is_atom(scene), do: {:ok, scene}
  def validate({scene, _} = data) when is_atom(scene), do: {:ok, data}

  def validate(data) do
    {
      :error,
      """
      #{IO.ANSI.red()} Invalid PonchoScenic.Component.Nav spec componenet
      recieved: #{inspect(data)}
      #{IO.ANSI.yellow()}
      Nav Component requires a valid scene module or {module, param}
      """
    }
  end

  @impl Scenic.Scene
  def init(scene, current_scene, opts) do
    {width, _height} = scene.viewport.size

    {background, text} =
      case opts[:theme] do
        :dark ->
          {{48, 48, 48}, :white}
        :light ->
          {{220, 220, 220}, :black}
        _ ->
          {{10, 123, 10}, :black}
      end

    graph =
      Graph.build(font: :roboto, font_size: 25)
      |> rect({width, @height}, fill: background)
      |> text("Event:", translate: {10, 40}, alight: :right, fill: text)
      |> dropdown(
        {[
          {"Welcome", Genomeur.Scene.Welcome},
          {"Chess", Genomeur.Scene.Chess},
          {"Ur", Genomeur.Scene.Ur},
          {"Demo", Genomeur.Scene.Demo},
          {"ChessPositionComponent", Genomeur.Component.ChessPosition}
          ## todo below
          # {"PositionTest", Genomeur.Position},
          # ## possibility of how to organize this
          # {"Tournament", Genomeur.Tournament},
          # {"Match", Genomeur.Matchup},
          # {"Game", Genomeur.Scene.Game},
          # {"Records", Genomeur.Scene.Records}

          # {"EventPicker", Genomeur.Scene.EventPicker},
          # {"ContextPicker", Genomeur.Scene.ContextPicker},
          # {"ViewPicker", Genomeur.Scene.ViewPicker},
        ], current_scene},
        id: :nav,
        translate: {100, 10}
      )
      |> toggle(
        opts[:theme] == :light,
        id: :light_or_dark_or_orange,
        theme: :secondary,
        translate: {width - 60, 20}
      )

      scene = push_graph(scene, graph)

      {:ok, scene}
  end

  # when a nav value is changed, send that back to the ViewPort with params
  @impl Scenic.Scene
  def handle_event({:value_changed, :nav, {scene_mod, param}}, _, scene) do
    ViewPort.set_root(scene.viewport, scene_mod, param)
    {:noreply, scene}
  end

    # when a nav value is changed, send that back to the ViewPort
  def handle_event({:value_changed, :nav, scene_mod}, _, scene) do
    ViewPort.set_root(scene.viewport, scene_mod)
    {:noreply, scene}
  end

    # when :light_or_dark_or_orange is changed,
    # send to viewport with appropriate theme
  def handle_event({:value_changed, :light_or_dark_or_orange, toggled}, _, scene) do
    case toggled do
      true -> ViewPort.set_theme(scene.viewport, :light)
      false -> ViewPort.set_theme(scene.viewport, :dark)
      :orange -> ViewPort.set_theme(scene.viewport, :orange)
    end

    {:noreply, scene}
  end
end
