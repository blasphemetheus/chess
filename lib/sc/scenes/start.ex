# defmodule Genomeur.Scene.Start do
#   use Scenic.Scene

#   def init(_args, opts) do
#     graph =
#       Graph.build(font_size: 30)
#       |> rectangle({1280, 800}, fill: {:image, img_bg})
#       |> my_menu_component(
#         [
#           {"New Game", :new_game},
#           {"Continue", :load_last_saved_game},
#           {"Settings", :show_settings_menu},
#         ],
#         t: {408, 580}
#       )

#       state = %{
#         graph: graph,
#         viewport: opts[:viewport]
#       }

#       {:ok, state, push: graph}
#   end

# end
