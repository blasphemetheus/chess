defmodule Genomeur.Scene.Chess do
  @moduledoc """
  This is all about the Chess game. Playing it. Show the board, show the players etc.
  """
  use Scenic.Scene
  alias Scenic.Graph
  import Scenic.Primitives
  import Scenic.Components
  import Scenic.PubSub
  # import Genomeur.Component.Notes
  # import Genomeur.Component.Nav
  alias Genomeur.Component.Nav
  alias Genomeur.Component.Notes
  alias Genomeur.PubSub.ChessComputers
  alias Scenic.PubSub

  @notes """
  This Chess scene will feature a chess board, that will be resizable
  via transforms. It'll be a group of components I think, unclear on how it'll work
  But first I'll make em in the brute force way a bit then
  hook em up to a group I think.
  """

  @all_colors_str_atom_tuple_list [
    {"Alice Blue", :alice_blue}, {"Antique White", :antique_white}, {"Aqua", :aqua}, {"Aquamarine", :aquamarine}, {"Azure", :azure}, {"Beige", :beige}, {"Bisque", :bisque},
    {"Black", :black}, {"Blanched Almond", :blanched_almond}, {"Blue", :blue}, {"Blue Violet", :blue_violet}, {"Brown", :brown}, {"Burly Wood", :burly_wood}, {"Cadet Blue", :cadet_blue},
    {"Chartreuse", :chartreuse}, {"Chocolate", :chocolate}, {"Coral", :coral}, {"Cornflower Blue", :cornflower_blue}, {"Cornsilk", :cornsilk}, {"Crimson", :crimson},
    {"Cyan", :cyan}, {"Dark Blue", :dark_blue}, {"Dark Cyan", :dark_cyan}, {"Dark Golden Rod", :dark_golden_rod}, {"Dark Green", :dark_green}, {"Dark Grey", :dark_grey},
    {"Dark Khaki", :dark_khaki}, {"Dark Magenta", :dark_magenta}, {"Dark Olive Green", :dark_olive_green}, {"Dark Orange", :dark_orange}, {"Dark Orchid", :dark_orchid},
    {"Dark Red", :dark_red}, {"Dark Salmon", :dark_salmon}, {"Dark Sea Green", :dark_sea_green}, {"Dark Slate Blue", :dark_slate_blue}, {"Dark Slate Grey", :dark_slate_grey},
    {"Dark Turquoise", :dark_turquoise}, {"Dark Violet", :dark_violet}, {"Deep Pink", :deep_pink}, {"Deep Sky Blue", :deep_sky_blue}, {"Dim Grey", :dim_grey}, {"Dodger Blue", :dodger_blue},
    {"Fire Brick", :fire_brick}, {"Floral White", :floral_white}, {"Forest Green", :forest_green}, {"Fuchsia", :fuchsia}, {"Gainsboro", :gainsboro}, {"Ghost White", :ghost_white},
    {"Gold", :gold}, {"Goldenrod", :golden_rod}, {"Grey", :grey}, {"Green", :green}, {"Green Yellow", :green_yellow}, {"Honeydew", :honey_dew}, {"Hot Pink", :hot_pink},
    {"Indian Red", :indian_red}, {"Indigo", :indigo}, {"Ivory", :ivory}, {"Khaki", :khaki}, {"Lavender", :lavender}, {"Lavender Blush", :lavender_blush}, {"Lawn Green", :lawn_green},
    {"Lemon Chiffon", :lemon_chiffon}, {"Light Blue", :light_blue}, {"Light Coral", :light_coral}, {"Light Cyan", :light_cyan}, {"Light Golden Rod", :light_golden_rod},
    {"Light Goldenrod Yellow", :light_golden_rod_yellow}, {"Light Green", :light_green}, {"Light Grey", :light_grey}, {"Light Pink", :light_pink}, {"Light Salmon", :light_salmon},
    {"Light Sea Green", :light_sea_green}, {"Light Sky Blue", :light_sky_blue}, {"Light Slate Grey", :light_slate_grey}, {"Light Steel Blue", :light_steel_blue}, {"Light Yellow", :light_yellow},
    {"Lime", :lime}, {"Lime Green", :lime_green}, {"Linen", :linen}, {"Magenta", :magenta}, {"Maroon", :maroon}, {"Medium Aquamarine", :medium_aqua_marine}, {"Medium Blue", :medium_blue},
    {"Medium Orchid", :medium_orchid}, {"Medium Purple", :medium_purple}, {"Medium Sea Green", :medium_sea_green}, {"Medium Slate Blue", :medium_slate_blue}, {"Medium Spring Green", :medium_spring_green},
    {"Medium Turquoise", :medium_turquoise}, {"Medium Violet Red", :medium_violet_red}, {"Midnight Blue", :midnight_blue}, {"Mint Cream", :mint_cream}, {"Misty Rose", :misty_rose},
    {"Moccasin", :moccasin}, {"Navajo White", :navajo_white}, {"Navy", :navy}, {"Old Lace", :old_lace}, {"Olive", :olive}, {"Olive Drab", :olive_drab}, {"Orange", :orange}, {"Orange Red", :orange_red},
    {"Orchid", :orchid}, {"Pale Goldenrod", :pale_golden_rod}, {"Pale Green", :pale_green}, {"Pale Turquoise", :pale_turquoise}, {"Pale Violet Red", :pale_violet_red}, {"Papaya Whip", :papaya_whip},
    {"Peach Puff", :peach_puff}, {"Peru", :peru}, {"Pink", :pink}, {"Plum",:plum}, {"Powder Blue",:powder_blue}, {"Purple", :purple}, {"Rebecca Purple",:rebecca_purple}, {"Red",:red},
    {"Rosy Brown", :rosy_brown}, {"Royal Blue", :royal_blue}, {"Saddle Brown", :saddle_brown}, {"Salmon", :salmon}, {"Sandy Brown", :sandy_brown}, {"Sea Green", :sea_green}, {"Sea Shell", :sea_shell}, {"Sienna", :sienna},
    {"Silver", :silver}, {"Sky Blue", :sky_blue}, {"Slate Blue", :slate_blue}, {"Slate Grey", :slate_grey}, {"Snow", :snow}, {"Spring Green", :spring_green}, {"Steel Blue", :steel_blue},
    {"Tan", :tan}, {"Teal", :teal}, {"Thistle", :thistle}, {"Tomato", :tomato}, {"Turquoise", :turquoise}, {"Violet", :violet}, {"Wheat", :wheat}, {"White", :white}, {"White Smoke", :white_smoke}, {"Yellow", :yellow}, {"Yellow Green", :yellow_green}
  ]

  @all_colors [:alice_blue, :antique_white, :aqua, :aquamarine, :azure, :beige, :bisque, :black, :blanched_almond, :blue, :blue_violet, :brown, :burly_wood, :cadet_blue, :chartreuse, :chocolate, :coral, :cornflower_blue, :cornsilk, :crimson, :cyan, :dark_blue, :dark_cyan, :dark_golden_rod, :dark_grey, :dark_green, :dark_grey, :dark_khaki, :dark_magenta, :dark_olive_green, :dark_orange, :dark_orchid, :dark_red, :dark_salmon, :dark_sea_green, :dark_slate_blue, :dark_slate_grey, :dark_turquoise, :dark_violet, :deep_pink, :deep_sky_blue, :dim_grey, :dodger_blue, :fire_brick, :floral_white, :forest_green, :fuchsia, :gainsboro, :ghost_white, :gold, :golden_rod, :green, :green_yellow, :grey, :honey_dew, :hot_pink, :indian_red, :indigo, :ivory, :khaki, :lavender, :lavender_blush, :lawn_green, :lemon_chiffon, :light_blue, :light_coral, :light_cyan, :light_golden_rod, :light_golden_rod_yellow, :light_green, :light_grey, :light_pink, :light_salmon, :light_sea_green, :light_sky_blue, :light_slate_grey, :light_steel_blue, :light_yellow, :lime, :lime_green, :linen, :magenta, :maroon, :medium_aqua_marine, :medium_blue, :medium_orchid, :medium_purple, :medium_sea_green, :medium_slate_blue, :medium_spring_green, :medium_turquoise, :medium_violet_red, :midnight_blue, :mint_cream, :misty_rose, :moccasin, :navajo_white, :navy, :old_lace, :olive, :olive_drab, :orange, :orange_red, :orchid, :pale_golden_rod, :pale_green, :pale_turquoise, :pale_violet_red, :papaya_whip, :peach_puff, :peru, :pink, :plum, :powder_blue, :purple, :rebecca_purple, :red, :rosy_brown, :royal_blue, :saddle_brown, :salmon, :sandy_brown, :sea_green, :sea_shell, :sienna, :silver, :sky_blue, :slate_blue, :slate_grey, :snow, :spring_green, :steel_blue, :tan, :teal, :thistle, :tomato, :turquoise, :violet, :wheat, :white, :white_smoke, :yellow, :yellow_green]

  @colors_first [{"Brown", :brown},{"Orange", :orange}, {"Thistle", :thistle}, {"Tomato", :tomato}, {"Turquoise", :turquoise}, {"Violet", :violet}, {"Wheat", :wheat}, {"White", :white}, {"White Smoke", :white_smoke}, {"Yellow", :yellow}, {"Yellow Green", :yellow_green}]
  @colors_second [{"Cadet Blue", :cadet_blue},{"Blue", :blue}, {"Chartreuse", :chartreuse}, {"Chocolate", :chocolate}, {"Coral", :coral}, {"Cornflower Blue", :cornflower_blue}, {"Cornsilk", :cornsilk}, {"Crimson", :crimson},
  {"Cyan", :cyan}, {"Dark Blue", :dark_blue}, {"Dark Cyan", :dark_cyan}]

  @pick_colors_first @colors_first ++ [{"<default>", :unpicked}]
  @pick_colors_second @colors_second ++ [{"<default>", :unpicked}]

  @first :brown
  @second :cadet_blue
  @first_bkg :orange
  @second_bkg :dark_blue

  @start_x 20
  @start_y 180
  @start_scale 1.0

  @row 50
  @col 50
  @y_buf @col - 5
  @x_buf 0
  @stroke 1

  @a8 {0 + @x_buf, 0 * @col + @y_buf}
  @a7 {0 + @x_buf, 1 * @col + @y_buf}
  @a6 {0 + @x_buf, 2 * @col + @y_buf}
  @a5 {0 + @x_buf, 3 * @col + @y_buf}
  @a4 {0 + @x_buf, 4 * @col + @y_buf}
  @a3 {0 + @x_buf, 5 * @col + @y_buf}
  @a2 {0 + @x_buf, 6 * @col + @y_buf}
  @a1 {0 + @x_buf, 7 * @col + @y_buf}

  @b8 {1 * @col + @x_buf, 0 * @col + @y_buf}
  @b7 {1 * @col + @x_buf, 1 * @col + @y_buf}
  @b6 {1 * @col + @x_buf, 2 * @col + @y_buf}
  @b5 {1 * @col + @x_buf, 3 * @col + @y_buf}
  @b4 {1 * @col + @x_buf, 4 * @col + @y_buf}
  @b3 {1 * @col + @x_buf, 5 * @col + @y_buf}
  @b2 {1 * @col + @x_buf, 6 * @col + @y_buf}
  @b1 {1 * @col + @x_buf, 7 * @col + @y_buf}

  @c8 {2 * @col + @x_buf, 0 * @col + @y_buf}
  @c7 {2 * @col + @x_buf, 1 * @col + @y_buf}
  @c6 {2 * @col + @x_buf, 2 * @col + @y_buf}
  @c5 {2 * @col + @x_buf, 3 * @col + @y_buf}
  @c4 {2 * @col + @x_buf, 4 * @col + @y_buf}
  @c3 {2 * @col + @x_buf, 5 * @col + @y_buf}
  @c2 {2 * @col + @x_buf, 6 * @col + @y_buf}
  @c1 {2 * @col + @x_buf, 7 * @col + @y_buf}

  @d8 {3 * @col + @x_buf, 0 * @col + @y_buf}
  @d7 {3 * @col + @x_buf, 1 * @col + @y_buf}
  @d6 {3 * @col + @x_buf, 2 * @col + @y_buf}
  @d5 {3 * @col + @x_buf, 3 * @col + @y_buf}
  @d4 {3 * @col + @x_buf, 4 * @col + @y_buf}
  @d3 {3 * @col + @x_buf, 5 * @col + @y_buf}
  @d2 {3 * @col + @x_buf, 6 * @col + @y_buf}
  @d1 {3 * @col + @x_buf, 7 * @col + @y_buf}

  @e8 {4 * @col + @x_buf, 0 * @col + @y_buf}
  @e7 {4 * @col + @x_buf, 1 * @col + @y_buf}
  @e6 {4 * @col + @x_buf, 2 * @col + @y_buf}
  @e5 {4 * @col + @x_buf, 3 * @col + @y_buf}
  @e4 {4 * @col + @x_buf, 4 * @col + @y_buf}
  @e3 {4 * @col + @x_buf, 5 * @col + @y_buf}
  @e2 {4 * @col + @x_buf, 6 * @col + @y_buf}
  @e1 {4 * @col + @x_buf, 7 * @col + @y_buf}

  @f8 {5 * @col + @x_buf, 0 * @col + @y_buf}
  @f7 {5 * @col + @x_buf, 1 * @col + @y_buf}
  @f6 {5 * @col + @x_buf, 2 * @col + @y_buf}
  @f5 {5 * @col + @x_buf, 3 * @col + @y_buf}
  @f4 {5 * @col + @x_buf, 4 * @col + @y_buf}
  @f3 {5 * @col + @x_buf, 5 * @col + @y_buf}
  @f2 {5 * @col + @x_buf, 6 * @col + @y_buf}
  @f1 {5 * @col + @x_buf, 7 * @col + @y_buf}

  @g8 {6 * @col + @x_buf, 0 * @col + @y_buf}
  @g7 {6 * @col + @x_buf, 1 * @col + @y_buf}
  @g6 {6 * @col + @x_buf, 2 * @col + @y_buf}
  @g5 {6 * @col + @x_buf, 3 * @col + @y_buf}
  @g4 {6 * @col + @x_buf, 4 * @col + @y_buf}
  @g3 {6 * @col + @x_buf, 5 * @col + @y_buf}
  @g2 {6 * @col + @x_buf, 6 * @col + @y_buf}
  @g1 {6 * @col + @x_buf, 7 * @col + @y_buf}

  @h8 {7 * @col + @x_buf, 0 * @col + @y_buf}
  @h7 {7 * @col + @x_buf, 1 * @col + @y_buf}
  @h6 {7 * @col + @x_buf, 2 * @col + @y_buf}
  @h5 {7 * @col + @x_buf, 3 * @col + @y_buf}
  @h4 {7 * @col + @x_buf, 4 * @col + @y_buf}
  @h3 {7 * @col + @x_buf, 5 * @col + @y_buf}
  @h2 {7 * @col + @x_buf, 6 * @col + @y_buf}
  @h1 {7 * @col + @x_buf, 7 * @col + @y_buf}

  @st_scale 1.0
  @x_st 100
  @x 11
  @y_st 100
  @y 11

  @body_offset 70

  @buttons [
    button_spec("Send Move", id: :send_it, height: 30, theme: :warning),
    button_spec("Settings", id: :settings,height: 20, theme: :secondary),
  ]

  @event_texts [
    text_spec("Unhandled EVENT TEXT", id: :event_text, t: {0, 800}),
    text_spec("Unhandled 2 EVENT TEXT", id: :event_text2, t: {00, 1000})
  ]

  @controltext [
    text_spec("X"),
    text_spec("Y", translate: {0, 20}),
    text_spec("Scale", translate: {0, 40}),
    button_spec("Show Possible Moves", t: {0, 500}),
    # second control column
    text_spec("First Color", translate: {500, 0}),
    text_spec("Second Color", translate: {500, 40}),
    text_spec("Background First", translate: {500, 80}),
    text_spec("Background Second", translate: {500, 120})
  ]

  @controlbuttons [
    slider_spec({{00, 500}, @start_x}, id: :pos_x),
    slider_spec({{180, 400}, 200}, id: :pos_y, translate: {0, 20}),
    slider_spec({{0.2, 3.0}, @start_scale}, id: :scale, translate: {0, 40}),
    slider_spec({{-1.5708, 1.5708}, 0}, id: :rotate_ui, translate: {0, 60}),
    # second control column sliders
    dropdown_spec({@pick_colors_second, @second_bkg}, id: :second_background_dropdown, translate: {500, 120}),
    dropdown_spec({@pick_colors_first, @first_bkg}, id: :first_background_dropdown, translate: {500, 80}),
    dropdown_spec({@pick_colors_second, @second}, id: :second_color, translate: {500, 40}),
    dropdown_spec({@pick_colors_first, @first}, id: :first_color, translate: {500, 0})
  ]

  @controltoggles [
    toggle_spec(true, id: :possible_moves_toggle, t: {20, 20}),
    toggle_spec(false, id: :moving_toggle, t: {0, 0})
  ]

  @controls [
    group_spec(@controltext, text_align: :right, t: {60, 20}),
    group_spec(@controlbuttons, translate: {70, 6}),
    group_spec(@controltoggles, translate: {0, 0})
  ]

  @the_board_buttons [
        # first row
    button_spec("", id: :a8_button, theme: :info, stroke: {@stroke, :black}, t: {0 * @row, 0 * @col}),
    button_spec("", id: :b8_button, theme: :info, stroke: {@stroke, :black}, t: {1 * @row, 0 * @col}),
    button_spec("", id: :c8_button, theme: :info, stroke: {@stroke, :black}, t: {2 * @row, 0 * @col}),
    button_spec("", id: :d8_button, theme: :info, stroke: {@stroke, :black}, t: {3 * @row, 0 * @col}),
    button_spec("", id: :e8_button, theme: :info, stroke: {@stroke, :black}, t: {4 * @row, 0 * @col}),
    button_spec("", id: :f8_button, theme: :info, stroke: {@stroke, :black}, t: {5 * @row, 0 * @col}),
    button_spec("", id: :g8_button, theme: :info, stroke: {@stroke, :black}, t: {6 * @row, 0 * @col}),
    button_spec("", id: :h8_button, theme: :info, stroke: {@stroke, :black}, t: {7 * @row, 0 * @col}),
    # second row
    button_spec("", id: :a7_button, theme: :info, stroke: {@stroke, :black}, t: {0 * @row, 1 * @col}),
    button_spec("", id: :b7_button, theme: :info, stroke: {@stroke, :black}, t: {1 * @row, 1 * @col}),
    button_spec("", id: :c7_button, theme: :info, stroke: {@stroke, :black}, t: {2 * @row, 1 * @col}),
    button_spec("", id: :d7_button, theme: :info, stroke: {@stroke, :black}, t: {3 * @row, 1 * @col}),
    button_spec("", id: :e7_button, theme: :info, stroke: {@stroke, :black}, t: {4 * @row, 1 * @col}),
    button_spec("", id: :f7_button, theme: :info, stroke: {@stroke, :black}, t: {5 * @row, 1 * @col}),
    button_spec("", id: :g7_button, theme: :info, stroke: {@stroke, :black}, t: {6 * @row, 1 * @col}),
    button_spec("", id: :h7_button, theme: :info, stroke: {@stroke, :black}, t: {7 * @row, 1 * @col}),
    # third row
    button_spec("", id: :a6_button, theme: :info, stroke: {@stroke, :black}, t: {0 * @row, 2 * @col}),
    button_spec("", id: :b6_button, theme: :info, stroke: {@stroke, :black}, t: {1 * @row, 2 * @col}),
    button_spec("", id: :c6_button, theme: :info, stroke: {@stroke, :black}, t: {2 * @row, 2 * @col}),
    button_spec("", id: :d6_button, theme: :info, stroke: {@stroke, :black}, t: {3 * @row, 2 * @col}),
    button_spec("", id: :e6_button, theme: :info, stroke: {@stroke, :black}, t: {4 * @row, 2 * @col}),
    button_spec("", id: :f6_button, theme: :info, stroke: {@stroke, :black}, t: {5 * @row, 2 * @col}),
    button_spec("", id: :g6_button, theme: :info, stroke: {@stroke, :black}, t: {6 * @row, 2 * @col}),
    button_spec("", id: :h6_button, theme: :info, stroke: {@stroke, :black}, t: {7 * @row, 2 * @col}),
    # fourth row
    button_spec("", id: :a5_button, theme: :info, stroke: {@stroke, :black}, t: {0 * @col, 3 * @col}),
    button_spec("", id: :b5_button, theme: :info, stroke: {@stroke, :black}, t: {1 * @col, 3 * @col}),
    button_spec("", id: :c5_button, theme: :info, stroke: {@stroke, :black}, t: {2 * @col, 3 * @col}),
    button_spec("", id: :d5_button, theme: :info, stroke: {@stroke, :black}, t: {3 * @col, 3 * @col}),
    button_spec("", id: :e5_button, theme: :info, stroke: {@stroke, :black}, t: {4 * @col, 3 * @col}),
    button_spec("", id: :f5_button, theme: :info, stroke: {@stroke, :black}, t: {5 * @col, 3 * @col}),
    button_spec("", id: :g5_button, theme: :info, stroke: {@stroke, :black}, t: {6 * @col, 3 * @col}),
    button_spec("", id: :h5_button, theme: :info, stroke: {@stroke, :black}, t: {7 * @col, 3 * @col}),
    # fifth row
    button_spec("", id: :a4_button, theme: :info, stroke: {@stroke, :black}, t: {0 * @col, 4 * @col}),
    button_spec("", id: :b4_button, theme: :info, stroke: {@stroke, :black}, t: {1 * @col, 4 * @col}),
    button_spec("", id: :c4_button, theme: :info, stroke: {@stroke, :black}, t: {2 * @col, 4 * @col}),
    button_spec("", id: :d4_button, theme: :info, stroke: {@stroke, :black}, t: {3 * @col, 4 * @col}),
    button_spec("", id: :e4_button, theme: :info, stroke: {@stroke, :black}, t: {4 * @col, 4 * @col}),
    button_spec("", id: :f4_button, theme: :info, stroke: {@stroke, :black}, t: {5 * @col, 4 * @col}),
    button_spec("", id: :g4_button, theme: :info, stroke: {@stroke, :black}, t: {6 * @col, 4 * @col}),
    button_spec("", id: :h4_button, theme: :info, stroke: {@stroke, :black}, t: {7 * @col, 4 * @col}),
    # sixth row
    button_spec("", id: :a3_button, theme: :info, stroke: {@stroke, :black}, t: {0 * @col, 5 * @col}),
    button_spec("", id: :b3_button, theme: :info, stroke: {@stroke, :black}, t: {1 * @col, 5 * @col}),
    button_spec("", id: :c3_button, theme: :info, stroke: {@stroke, :black}, t: {2 * @col, 5 * @col}),
    button_spec("", id: :d3_button, theme: :info, stroke: {@stroke, :black}, t: {3 * @col, 5 * @col}),
    button_spec("", id: :e3_button, theme: :info, stroke: {@stroke, :black}, t: {4 * @col, 5 * @col}),
    button_spec("", id: :f3_button, theme: :info, stroke: {@stroke, :black}, t: {5 * @col, 5 * @col}),
    button_spec("", id: :g3_button, theme: :info, stroke: {@stroke, :black}, t: {6 * @col, 5 * @col}),
    button_spec("", id: :h3_button, theme: :info, stroke: {@stroke, :black}, t: {7 * @col, 5 * @col}),
    # seventh row
    button_spec("", id: :a2_button, theme: :info, stroke: {@stroke, :black}, t: {0 * @row, 6 * @col}),
    button_spec("", id: :b2_button, theme: :info, stroke: {@stroke, :black}, t: {1 * @row, 6 * @col}),
    button_spec("", id: :c2_button, theme: :info, stroke: {@stroke, :black}, t: {2 * @row, 6 * @col}),
    button_spec("", id: :d2_button, theme: :info, stroke: {@stroke, :black}, t: {3 * @row, 6 * @col}),
    button_spec("", id: :e2_button, theme: :info, stroke: {@stroke, :black}, t: {4 * @row, 6 * @col}),
    button_spec("", id: :f2_button, theme: :info, stroke: {@stroke, :black}, t: {5 * @row, 6 * @col}),
    button_spec("", id: :g2_button, theme: :info, stroke: {@stroke, :black}, t: {6 * @row, 6 * @col}),
    button_spec("", id: :h2_button, theme: :info, stroke: {@stroke, :black}, t: {7 * @row, 6 * @col}),
    # eighth row
    button_spec("", id: :a1_button, theme: :info, stroke: {@stroke, :black}, t: {0 * @col, 7 * @col}),
    button_spec("", id: :b1_button, theme: :info, stroke: {@stroke, :black}, t: {1 * @col, 7 * @col}),
    button_spec("", id: :c1_button, theme: :info, stroke: {@stroke, :black}, t: {2 * @col, 7 * @col}),
    button_spec("", id: :d1_button, theme: :info, stroke: {@stroke, :black}, t: {3 * @col, 7 * @col}),
    button_spec("", id: :e1_button, theme: :info, stroke: {@stroke, :black}, t: {4 * @col, 7 * @col}),
    button_spec("", id: :f1_button, theme: :info, stroke: {@stroke, :black}, t: {5 * @col, 7 * @col}),
    button_spec("", id: :g1_button, theme: :info, stroke: {@stroke, :black}, t: {6 * @col, 7 * @col}),
    button_spec("", id: :h1_button, theme: :info, stroke: {@stroke, :black}, t: {7 * @col, 7 * @col})

  ]

  @the_board [
    # first row
    rect_spec({@row, @col}, id: :a8, t: {0, 0 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :b8, t: {0, 1 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :c8, t: {0, 2 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :d8, t: {0, 3 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :e8, t: {0, 4 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :f8, t: {0, 5 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :g8, t: {0, 6 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :h8, t: {0, 7 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    # second row
    rect_spec({@row, @col}, id: :a7, t: {@col, 0 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :b7, t: {@col, 1 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :c7, t: {@col, 2 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :d7, t: {@col, 3 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :e7, t: {@col, 4 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :f7, t: {@col, 5 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :g7, t: {@col, 6 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :h7, t: {@col, 7 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    # third row
    rect_spec({@row, @col}, id: :a6, t: {2 * @row, 0 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :b6, t: {2 * @row, 1 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :c6, t: {2 * @row, 2 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :d6, t: {2 * @row, 3 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :e6, t: {2 * @row, 4 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :f6, t: {2 * @row, 5 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :g6, t: {2 * @row, 6 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :h6, t: {2 * @row, 7 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    # fourth row
    rect_spec({@row, @col}, id: :a5, t: {3 * @col, 0 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :b5, t: {3 * @col, 1 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :c5, t: {3 * @col, 2 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :d5, t: {3 * @col, 3 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :e5, t: {3 * @col, 4 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :f5, t: {3 * @col, 5 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :g5, t: {3 * @col, 6 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :h5, t: {3 * @col, 7 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    # fifth row
    rect_spec({@row, @col}, id: :a4, t: {4 * @col, 0 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :b4, t: {4 * @col, 1 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :c4, t: {4 * @col, 2 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :d4, t: {4 * @col, 3 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :e4, t: {4 * @col, 4 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :f4, t: {4 * @col, 5 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :g4, t: {4 * @col, 6 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :h4, t: {4 * @col, 7 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    # sixth row
    rect_spec({@row, @col}, id: :a3, t: {5 * @col, 0 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :b3, t: {5 * @col, 1 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :c3, t: {5 * @col, 2 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :d3, t: {5 * @col, 3 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :e3, t: {5 * @col, 4 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :f3, t: {5 * @col, 5 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :g3, t: {5 * @col, 6 * @col}, fill: @second_bkg, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :h3, t: {5 * @col, 7 * @col}, fill: @first_bkg, id: :first_tile, stroke: {@stroke, :black}),
    # seventh row
    rect_spec({@row, @col}, id: :a2, t: {6 * @row, 0 * @col}, fill: @first_bkg, id: :first_tile, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :b2, t: {6 * @row, 1 * @col}, fill: @second_bkg, id: :second_tile, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :c2, t: {6 * @row, 2 * @col}, fill: @first_bkg, id: :first_tile, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :d2, t: {6 * @row, 3 * @col}, fill: @second_bkg, id: :second_tile, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :e2, t: {6 * @row, 4 * @col}, fill: @first_bkg, id: :first_tile, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :f2, t: {6 * @row, 5 * @col}, fill: @second_bkg, id: :second_tile, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :g2, t: {6 * @row, 6 * @col}, fill: @first_bkg, id: :first_tile, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :h2, t: {6 * @row, 7 * @col}, fill: @second_bkg, id: :second_tile, id: :second_tile, stroke: {@stroke, :black}),
    # eighth row
    rect_spec({@row, @col}, id: :a1, t: {7 * @col, 0 * @col}, fill: @second_bkg, id: :second_tile, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :b1, t: {7 * @col, 1 * @col}, fill: @first_bkg, id: :first_tile, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :c1, t: {7 * @col, 2 * @col}, fill: @second_bkg, id: :second_tile, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :d1, t: {7 * @col, 3 * @col}, fill: @first_bkg, id: :first_tile, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :e1, t: {7 * @col, 4 * @col}, fill: @second_bkg, id: :second_tile, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :f1, t: {7 * @col, 5 * @col}, fill: @first_bkg, id: :first_tile, id: :first_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :g1, t: {7 * @col, 6 * @col}, fill: @second_bkg, id: :second_tile, id: :second_tile, stroke: {@stroke, :black}),
    rect_spec({@row, @col}, id: :h1, t: {7 * @col, 7 * @col}, fill: @first_bkg, id: :first_tile, id: :first_tile, stroke: {@stroke, :black})
  ]

  @first_pieces [
    # pawns
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :first_color, t: @a2),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :first_color, t: @b2),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :first_color, t: @c2),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :first_color, t: @d2),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :first_color, t: @e2),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :first_color, t: @f2),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :first_color, t: @g2),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :first_color, t: @h2),
    # backrank pieces
    text_spec(ScenicUtils.renderFont(:filled, :rook, :chess_font), id: :first_color, t: @a1),
    text_spec(ScenicUtils.renderFont(:filled, :knight, :chess_font), id: :first_color, t: @b1),
    text_spec(ScenicUtils.renderFont(:filled, :bishop, :chess_font), id: :first_color, t: @c1),
    text_spec(ScenicUtils.renderFont(:filled, :queen, :chess_font), id: :first_color, t: @d1),
    text_spec(ScenicUtils.renderFont(:filled, :king, :chess_font), id: :first_color, t: @e1),
    text_spec(ScenicUtils.renderFont(:filled, :bishop, :chess_font), id: :first_color, t: @f1),
    text_spec(ScenicUtils.renderFont(:filled, :knight, :chess_font), id: :first_color, t: @g1),
    text_spec(ScenicUtils.renderFont(:filled, :rook, :chess_font), id: :first_color, t: @h1)
  ]

  @second_pieces [
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :second_color, t: @a7),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :second_color, t: @b7),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :second_color, t: @c7),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :second_color, t: @d7),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :second_color, t: @e7),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :second_color, t: @f7),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :second_color, t: @g7),
    text_spec(ScenicUtils.renderFont(:filled, :pawn, :chess_font), id: :second_color, t: @h7),
    # backrank pieces
    text_spec(ScenicUtils.renderFont(:filled, :rook, :chess_font), id: :second_color, t: @a8),
    text_spec(ScenicUtils.renderFont(:filled, :knight, :chess_font), id: :second_color, t: @b8),
    text_spec(ScenicUtils.renderFont(:filled, :bishop, :chess_font), id: :second_color, t: @c8),
    text_spec(ScenicUtils.renderFont(:filled, :queen, :chess_font), id: :second_color, t: @d8),
    text_spec(ScenicUtils.renderFont(:filled, :king, :chess_font), id: :second_color, t: @e8),
    text_spec(ScenicUtils.renderFont(:filled, :bishop, :chess_font), id: :second_color, t: @f8),
    text_spec(ScenicUtils.renderFont(:filled, :knight, :chess_font), id: :second_color, t: @g8),
    text_spec(ScenicUtils.renderFont(:filled, :rook, :chess_font), id: :second_color, t: @h8)
  ]

  @pieces [
    group_spec(@first_pieces, id: :first_pieces, fill: :brown),
    group_spec(@second_pieces, id: :second_pieces, fill: :cyan)
  ]

  @all_pieces_empty [
    text_spec("cool", id: :test, t: {20, 20})
  ]

  @whole_board [
    group_spec(@the_board, translate: {0, 0}, id: :the_board, pin: {4 * @col, 4 * @row}),
    group_spec(@the_board_buttons, t: {0, 0}, id: :the_board_buttons),
    group_spec(@pieces, id: :pieces, font_size: 50, align: :left, font: :chess_font),
    group_spec(@all_pieces_empty, id: :all_pieces, font_size: 50, align: :left, font: :chess_font)
  ]

  @graph Graph.build(font: :belligerent, font_size: 20)
    |> add_specs_to_graph(
      [
        group_spec(@event_texts, translate: {0, 0}),
        button_spec("yes", t: {800, 800}),
        group_spec(@buttons, id: :button_group, button_font_size: 24),
        group_spec(@controls, translate: {0, 70}),
        group_spec(@whole_board, translate: {@start_x, @start_y}, pin: {100, 25}, id: :whole_board),
      ], translate: {0, @body_offset}
    )
        # |> slider({{-1.5708 * 2, 1.5708 * 2}, 0}, id: :rotate_board, translate: {0, 9 * @col}, width: 200)
        # |> slider({{0, 200}, 0}, id: :vertical_board, translate: {0, 10 * @col}, width: 200)
    |> Notes.add_to_graph(@notes)
    |> Nav.add_to_graph(__MODULE__)

  @impl Scenic.Scene
  def init(scene, _param, _opts) do
    PubSub.subscribe(:chess_computers)
    graph = @graph

    scene =
      scene
      |> assign(graph: graph, x: @x_st, y: @y_st)
      |> push_graph(graph)

    {:ok, scene}
  end

  @impl Scenic.Scene
  def handle_event({:value_changed, :pos_x, x}, _, %{assigns: %{graph: graph, y: y}} = scene) do
    graph = Graph.modify(graph, :whole_board, &update_opts(&1, translate: {x, y}))

    scene =
      scene
      |> assign(graph: graph, x: x)
      |> push_graph(graph)

    {:halt, scene}
  end

  def handle_event({:value_changed, :pos_y, y}, _, %{assigns: %{graph: graph, x: x}} = scene) do
    graph = Graph.modify(graph, :whole_board, &update_opts(&1, translate: {x, y}))

    scene =
      scene
      |> assign(graph: graph, y: y)
      |> push_graph(graph)

    {:halt, scene}
  end

  def handle_event({:value_changed, :scale, scale}, _, %{assigns: %{graph: graph}} = scene) do
    graph = Graph.modify(graph, :whole_board, &update_opts(&1, scale: scale))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:halt, scene}
  end

  def handle_event({:value_changed, :rotate_ui, angle}, _, %{assigns: %{graph: graph}} = scene) do
    graph = Graph.modify(graph, :whole_board, &update_opts(&1, rotate: angle))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:halt, scene}
  end

  def handle_event({:value_changed, :rotate_board, angle}, _, %{assigns: %{graph: graph}} = scene) do
    graph = Graph.modify(graph, :the_board, &update_opts(&1, rotate: angle))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:halt, scene}
  end

  # when the vertical_board slider moves, the y value of the_board is updated
  def handle_event({:value_changed, :vertical_board, y}, _, %{assigns: %{graph: graph, x: x}} = scene) do
    graph = Graph.modify(graph, :the_board, &update_opts(&1, translate: {x, y}))

    scene =
      scene
      |> assign(graph: graph, y: y)
      |> push_graph(graph)

    {:halt, scene}
  end

  # when the color picker color changes, change every first color id to that color with fill
  def handle_event({:value_changed, :first_color, new_color}, _, %{assigns: %{graph: graph}} = scene) do
    graph = Graph.modify(graph, :first_color, &update_opts(&1, fill: new_color))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:halt, scene}
  end

  # when the color picker color changes, change every first color id to that color with fill
  def handle_event({:value_changed, :second_color, new_color}, _, %{assigns: %{graph: graph}} = scene) do
    graph = Graph.modify(graph, :second_color, &update_opts(&1, fill: new_color)) |> Graph.modify(:second_color_label, &text(&1, inspect(new_color)))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:halt, scene}
  end

  # when the color picker color changes, change every first color id to that color with fill
  def handle_event({:value_changed, :first_background_dropdown, new_color}, _, %{assigns: %{graph: graph}} = scene) do
    graph = Graph.modify(graph, :first_tile, &update_opts(&1, fill: new_color))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:halt, scene}
  end

  # when the color picker color changes, change every first color id to that color with fill
  def handle_event({:value_changed, :second_background_dropdown, new_color}, _, %{assigns: %{graph: graph}} = scene) do
    graph = Graph.modify(graph, :second_tile, &update_opts(&1, fill: new_color))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:halt, scene}
  end

    # any event update event_text
    def handle_event(event, _, %{assigns: %{graph: graph}} = scene) do
      graph = Graph.modify(graph, :event_text, &text(&1, (Enum.random(0..200) |> Integer.to_string()) <> "#{inspect(event)}"))

      scene = push_graph(scene, graph)

      {:noreply, scene}
    end

  # display the received message
  def handle_event(event, _, scene) do
    graph = Graph.modify(graph(), :event_text2, &text(&1, "oo: " <> inspect(event)))

    scene = push_graph(scene, graph)

    {:noreply, scene}
  end

  def graph(), do: @graph

  # def handle_info({Scenic.PubSub, :data}, {:chess_computers, gamerunner, id} = state) do
  #   IO.puts("GameRunner: #{inspect(gamerunner)}")
  #   {:halt, state}
  # end

  # def handle_info({Scenic.PubSub, :data}, {:chess_computers, gamerunner, id} = state, scene) do
  #   IO.puts("GameRunner: #{inspect(gamerunner)}")
  #   {:halt, state}
  # end

  @impl true
  def handle_info({{Scenic.PubSub, :data}, {:chess_computers, gr, id}}, %{assigns: %{graph: graph}} = sc) do
    IO.puts("Gamerunner:: #{inspect(gr)} and id: #{inspect(id)}")
    IO.puts("")

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
    IO.puts("GameRunner: #{inspect(thing)}")
    {:halt, thing}
  end

end
