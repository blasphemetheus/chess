defmodule Genomeur.Position do
  @moduledoc """
  THIS ONE IS IMPORTED FROM THE EXAMPLE SCENIC APP
  Online Tutorial etc.
  A component which is about showing how them graphs do.
  """
  use Scenic.Component
  alias Scenic.Graph
  import Scenic.Primitives, only: [{:text, 3}]#, {:update_opts, 2}]

  def validate(text) when is_bitstring(text), do: {:ok, text}
  def validate(txt) when is_atom(txt) or is_list(txt) do
    {:ok, txt}
  end
  def validate(_), do: :invalid_data


  def init(scene, _text, _opts) do
    # modify graph that's been built

    graph = Graph.build()
    |> text("", text_align: :center, translate: {100, 200}, id: :text)

    scene =
      scene
      |> assign(graph: graph, my_value: 123)
      |> push_graph(graph)

      {:ok, scene}
  end

  def position(graph, data, options \\ []) do
    graph
    |> add_to_graph(data, options)
  end
end
