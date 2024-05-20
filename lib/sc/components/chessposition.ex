defmodule Genomeur.Component.ChessPosition do
  @moduledoc """
  A component that shows a position in chess.
  """
  use Scenic.Component

  alias Scenic.ViewPort
  alias Scenic.Graph

  import Scenic.Primitives
  import Scenic.Components
  import Chessboard
  import GameRunner

  @height 60

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
  {"Cyan", :cyan}, {"Dark Blue", :dark_blue}, {"Dark Cyan", :dark_cyan}, {"Light Blue", :light_blue}]

  @pick_colors_first @colors_first ++ [{"<default>", :unpicked}]
  @pick_colors_second @colors_second ++ [{"<default>", :unpicked}]

  @first :brown
  @second :light_blue
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
  @buf 3

  @buf2 @buf * 2

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

  @controltext [
    text_spec("Scale", translate: {0, 40}),
    button_spec("Show Possible Moves", id: :possible_moves_button, t: {0, 600}),
    # second control column
    text_spec("First Color", translate: {500, 0}),
    text_spec("Second Color", translate: {500, 40}),
    text_spec("Background First", translate: {500, 80}),
    text_spec("Background Second", translate: {500, 120})
  ]

  @controlbuttons [
    button_spec("Send Move", id: :send_it, height: 30, theme: :warning),
    button_spec("Settings", id: :settings, height: 20, theme: :secondary, t: {200, 00}),
    button_spec("Show Game", id: :show_game, height: 20, theme: :secondary, t: {300, 00}),
    slider_spec({{0.2, 3.0}, @start_scale}, id: :scale, translate: {0, 40}),
    # second control column sliders
    dropdown_spec({@pick_colors_second, @second_bkg}, id: :second_background_dropdown, translate: {500, 120}),
    dropdown_spec({@pick_colors_first, @first_bkg}, id: :first_background_dropdown, translate: {500, 80}),
    dropdown_spec({@pick_colors_second, @second}, id: :second_color_dropdown, translate: {500, 40}),
    dropdown_spec({@pick_colors_first, @first}, id: :first_color_dropdown, translate: {500, 0})
  ]

  @promote_box_n_buttons [
    button_spec("Rook", id: :promote_rook, theme: :warning, hidden: true, t: {0, 0}),
    button_spec("Knight", id: :promote_knight, theme: :warning, hidden: true, t: {0, 5}),
    button_spec("Bishop", id: :promote_bishop, theme: :warning, hidden: true, t: {0, 10}),
    button_spec("Queen", id: :promote_queen, theme: :warning, hidden: true, t: {0, 0}),

    rect_spec({500, 500}, id: :occluding_box, hidden: :false)
  ]



  @spacer 15
  @iter 30

  @controltoggles [
    toggle_spec(false, id: :moving_toggle, t: {750, 0}),
    toggle_spec(true, id: :possible_moves_toggle, t: {750, @iter}),
    toggle_spec(false, id: :selected_toggle, t: {30, 700}),
    toggle_spec(true, id: :send_it_toggle, t: {750, 2 * @iter}),
    toggle_spec(false, id: :move_to_toggle, t: {750, 3 * @iter}),
    toggle_spec(false, id: :promote_type_toggle, t: {750, 4 * @iter}),

    text_spec("Unclicked Moving", id: :moving_tag, t: {800, 0 + @spacer}),
    text_spec("Unclicked Possible Moves", id: :possible_moves_tag, t: {800, @iter + @spacer}),
    text_spec("UNSELECTED", id: :selected_tag, t: {0, 700}),
    text_spec("Send it", id: :send_it_tag, t: {800, 2 * @iter + @spacer}),
    text_spec("UNSELECTED", id: :move_to_tag, t: {800, 3 * @iter + @spacer}),
    text_spec("Promote Type:", id: :promote_type_label, t: {800, 4 * @iter + @spacer}),
    text_spec("UNSELECTED", id: :promote_type_tag, t: {800, 5 * @iter + @spacer}),

    text_spec("Turn:", id: :turn_label, t: {800, 6 * @iter + @spacer}),
    text_spec(":orange", id: :turn_tag, t: {800, 7 * @iter + @spacer}),
    rect_spec({30, 30}, id: :turn_rect, t: {800, 8 * @iter + @spacer}),
  ]

  @controls [
    group_spec(@controltext, text_align: :right, t: {60, 20}),
    group_spec(@controlbuttons, translate: {70, 6}),
    group_spec(@controltoggles, translate: {0, 0}),

    text_spec("Unhandled EVENT TEXT", id: :event_text, t: {0, 800}),
    text_spec("Unhandled 2 EVENT TEXT", id: :event_text2, t: {00, 1000})
  ]

  @the_board_buttons [
        # first row
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :a8_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {0 * @row + @buf, 0 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :b8_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {1 * @row + @buf, 0 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :c8_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {2 * @row + @buf, 0 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :d8_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {3 * @row + @buf, 0 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :e8_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {4 * @row + @buf, 0 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :f8_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {5 * @row + @buf, 0 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :g8_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {6 * @row + @buf, 0 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :h8_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {7 * @row + @buf, 0 * @col + @buf}),
    # second row
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :a7_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {0 * @row + @buf, 1 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :b7_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {1 * @row + @buf, 1 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :c7_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {2 * @row + @buf, 1 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :d7_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {3 * @row + @buf, 1 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :e7_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {4 * @row + @buf, 1 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :f7_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {5 * @row + @buf, 1 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :g7_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {6 * @row + @buf, 1 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :h7_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {7 * @row + @buf, 1 * @col + @buf}),
    # third row
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :a6_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {0 * @row + @buf, 2 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :b6_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {1 * @row + @buf, 2 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :c6_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {2 * @row + @buf, 2 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :d6_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {3 * @row + @buf, 2 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :e6_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {4 * @row + @buf, 2 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :f6_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {5 * @row + @buf, 2 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :g6_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {6 * @row + @buf, 2 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :h6_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {7 * @row + @buf, 2 * @col + @buf}),
    # fourth row
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :a5_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {0 * @col + @buf, 3 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :b5_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {1 * @col + @buf, 3 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :c5_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {2 * @col + @buf, 3 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :d5_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {3 * @col + @buf, 3 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :e5_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {4 * @col + @buf, 3 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :f5_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {5 * @col + @buf, 3 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :g5_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {6 * @col + @buf, 3 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :h5_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {7 * @col + @buf, 3 * @col + @buf}),
    # fifth row
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :a4_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {0 * @col + @buf, 4 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :b4_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {1 * @col + @buf, 4 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :c4_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {2 * @col + @buf, 4 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :d4_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {3 * @col + @buf, 4 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :e4_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {4 * @col + @buf, 4 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :f4_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {5 * @col + @buf, 4 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :g4_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {6 * @col + @buf, 4 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :h4_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {7 * @col + @buf, 4 * @col + @buf}),
    # sixth row
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :a3_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {0 * @col + @buf, 5 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :b3_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {1 * @col + @buf, 5 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :c3_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {2 * @col + @buf, 5 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :d3_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {3 * @col + @buf, 5 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :e3_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {4 * @col + @buf, 5 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :f3_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {5 * @col + @buf, 5 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :g3_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {6 * @col + @buf, 5 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :h3_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {7 * @col + @buf, 5 * @col + @buf}),
    # seventh row
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :a2_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {0 * @row + @buf, 6 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :b2_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {1 * @row + @buf, 6 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :c2_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {2 * @row + @buf, 6 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :d2_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {3 * @row + @buf, 6 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :e2_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {4 * @row + @buf, 6 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :f2_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {5 * @row + @buf, 6 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :g2_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {6 * @row + @buf, 6 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :h2_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {7 * @row + @buf, 6 * @col + @buf}),
    # eighth row
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :a1_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {0 * @col + @buf, 7 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :b1_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {1 * @col + @buf, 7 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :c1_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {2 * @col + @buf, 7 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :d1_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {3 * @col + @buf, 7 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :e1_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {4 * @col + @buf, 7 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :f1_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {5 * @col + @buf, 7 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :g1_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {6 * @col + @buf, 7 * @col + @buf}),
    button_spec("", width: @row - @buf2, height: @col - @buf2, id: :h1_button, hidden: false, theme: :info, stroke: {@stroke, :black}, t: {7 * @col + @buf, 7 * @col + @buf})
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

  @whole_board [
    group_spec(@the_board, translate: {0, 0}, id: :the_board, pin: {4 * @col, 4 * @row}),
    group_spec(@the_board_buttons, t: {0, 0}, id: :the_board_buttons),
  ]

  @tag "me"
  @opp_tag "you"

  @initial_game %GameRunner{
    board: Chessboard.createBoard(),
    turn: :orange,
    first: %Player{type: :computer, color: :orange, tag: @tag, lvl: 1},
    second: %Player{type: :computer, color: :blue, tag: @opp_tag, lvl: 1},
    status: :in_progress,
    history: [],
    resolution: nil,
    reason: nil
  }

  @graph Graph.build(font: :belligerent, font_size: 20)
    |> add_specs_to_graph(
      [
        group_spec(@controls, t: {0, 0}),
        group_spec(@whole_board, translate: {@start_x, @start_y}, pin: {100, 25}, id: :whole_board),
        group_spec(@promote_box_n_buttons, t: {300, 300}),
      ], translate: {0, @body_offset}
    )

  @promote_type_options Chessboard.promotingOptions()

  @namedColors [:alice_blue, :antique_white, :aqua, :aquamarine, :azure, :beige, :bisque, :black, :blanched_almond, :blue, :blue_violet, :brown, :burly_wood, :cadet_blue, :chartreuse, :chocolate, :coral, :cornflower_blue, :cornsilk, :crimson, :cyan, :dark_blue, :dark_cyan, :dark_golden_rod, :dark_gray, :dark_green, :dark_grey, :dark_khaki, :dark_magenta, :dark_olive_green, :dark_orange, :dark_orchid, :dark_red, :dark_salmon, :dark_sea_green, :dark_slate_blue, :dark_slate_gray, :dark_slate_grey, :dark_turquoise, :dark_violet, :deep_pink, :deep_sky_blue, :dim_gray, :dim_grey, :dodger_blue, :fire_brick, :floral_white, :forest_green, :fuchsia, :gainsboro, :ghost_white, :gold, :golden_rod, :gray, :green, :green_yellow, :grey, :honey_dew, :hot_pink, :indian_red, :indigo, :ivory, :khaki, :lavender, :lavender_blush, :lawn_green, :lemon_chiffon, :light_blue, :light_coral, :light_cyan, :light_golden_rod, :light_golden_rod_yellow, :light_gray, :light_green, :light_grey, :light_pink, :light_salmon, :light_sea_green, :light_sky_blue, :light_slate_gray, :light_slate_grey, :light_steel_blue, :light_yellow, :lime, :lime_green, :linen, :magenta, :maroon, :medium_aqua_marine, :medium_blue, :medium_orchid, :medium_purple, :medium_sea_green, :medium_slate_blue, :medium_spring_green, :medium_turquoise, :medium_violet_red, :midnight_blue, :mint_cream, :misty_rose, :moccasin, :navajo_white, :navy, :old_lace, :olive, :olive_drab, :orange, :orange_red, :orchid, :pale_golden_rod, :pale_green, :pale_turquoise, :pale_violet_red, :papaya_whip, :peach_puff, :peru, :pink, :plum, :powder_blue, :purple, :rebecca_purple, :red, :rosy_brown, :royal_blue, :saddle_brown, :salmon, :sandy_brown, :sea_green, :sea_shell, :sienna, :silver, :sky_blue, :slate_blue, :slate_gray, :slate_grey, :snow, :spring_green, :steel_blue, :tan, :teal, :thistle, :tomato, :turquoise, :violet, :wheat, :white, :white_smoke, :yellow, :yellow_green]
  @doc """
  Given a type of text (outline or filled), a string representing the piece, and a font atom,
  return the correct character for the font
  """
  def renderFont(:outline, piece, :chess_font) do
    case piece do
      :pawn -> "p"
      :bishop -> "b"
      :rook -> "r"
      :knight -> "h"
      :king -> "k"
      :queen -> "q"
    end
  end

  def renderFont(:filled, piece, :chess_font) do
    case piece do
      :pawn -> "o"
      :bishop -> "n"
      :rook -> "t"
      :knight -> "j"
      :king -> "l"
      :queen -> "w"
    end
  end

  @doc """
  Given a graph and a game, replace render the game in the graph
  """
  def render_game(graph, game) do
    board = game.board
    first_color = grab_current_color(:orange, graph)
    second_color = grab_current_color(:blue, graph)

    first_pieces = Chessboard.fetch_locations(board.placements, :orange) |> change_color_to(first_color)
    second_pieces = Chessboard.fetch_locations(board.placements, :blue) |> change_color_to(second_color)
    first_group_spec = group_spec(produce_piece_spec_list(first_pieces, :first), id: :second_pieces, fill: :purple)
    second_group_spec = group_spec(produce_piece_spec_list(second_pieces, :second), id: :first_pieces, fill: :cyan)

    piece_list = [first_group_spec, second_group_spec]

    new_graph = graph
    |> Graph.delete(:pieces)
    |> Graph.modify(:turn_tag, &text(&1, "#{game.turn}"))
    |> Graph.modify(:turn_square, &rect(&1, {30, 30}))
    |> add_specs_to_graph(piece_list, font: :chess_font, id: :pieces, font_size: 50, align: :left)

    new_graph
  end

  def produce_piece_spec(loc, color, type, :first) do
    text_spec(renderFont(:filled, type, :chess_font), fill: color, id: :first_color, t: loc |> board_sc_loc() |> adjust_xy() |> adjust_start_xy())
  end

  def produce_piece_spec(loc, color, type, :second) do
    text_spec(renderFont(:filled, type, :chess_font), fill: color, id: :second_color, t: loc |> board_sc_loc() |> adjust_xy() |> adjust_start_xy())
  end

  def change_color_to(list_loc_placement_tuples, new_color) do
    list_loc_placement_tuples
    |> Enum.map(fn {loc, {_color, type}} -> {loc, {new_color, type}} end)
  end

  @doc """
  Given a piece_list and the atom first or the atom second, convert the list to a piece_spec list
  of the appropriate color (fill: :appropriate_color), where the color is retrieved from the state
  """
  def produce_piece_spec_list(piece_list, first_or_second) do
    piece_list
    |> Enum.map(fn {loc, {color, type}} -> produce_piece_spec(loc, color, type, first_or_second) end)
  end

  @doc """
  given a scene or a tuple of scene and something else, return an ok tuple with that input, otherwise return an error tuple
  """
  @impl Scenic.Component
  def validate(scene) when is_struct(scene), do: {:ok, scene}
  def validate({scene, _} = data) when is_struct(scene), do: {:ok, data}

  def validate(data) do
    {
      :error,
      """
      #{IO.ANSI.red()}#{IO.ANSI.default_background()} Invalid PonchoScenic.Component.ChessPosition spec componenet
      recieved: #{inspect(data)}
      #{IO.ANSI.yellow()}
      Nav Component requires a valid scene GameRunner or Board or {<struct>, param}
      """
    }
  end

  @doc """
  Given a scene, some other stuff and options, set the theme, set the initial game, set the initial graph
  and morph the scene to reflect the graph, return the scene with an ok tuple
  """
  @impl Scenic.Scene
  def init(scene, _current_scene, opts) do
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

    game =
      @initial_game

    graph =
      @graph
      |> rect({width, @height}, fill: background)
      |> text("Event:", translate: {10, 40}, align: :right, fill: text)
      |> toggle(
        opts[:theme] == :light,
        id: :light_or_dark_or_orange,
        theme: :secondary,
        translate: {width - 60, 20}
      )
      |> render_game(game)

      scene =
        scene
        |> morphscene_game(game)
        |> morphscene(graph)

      {:ok, scene}
  end

  @doc """
  Given a scene (with a game) and a location, apply the appropriate changes to the scenes to show
  possible moves, returning a tuple of :noreply and the new_scene
  """
  def attempt_show_possible_moves(%{assigns: %{game: game}} = scene, loc) do
    message("#{inspect loc}", :attempt_show_possible_moves, IO.ANSI.magenta)
    # is_selected isn't necessarily set on the board yet
    with {:selected_is_mt, false} <- {:selected_is_mt, Chessboard.get_at(game.board.placements, loc) == :mt},
         {:show_possible_moves_on, true} <- {:show_possible_moves_on, scene |> show_moves?()} do

      # set selected to new_click, change toggles, show possible moves, show selected
      moves = Chessboard.possible_moves(game.board, loc)
      is_empty = moves == []
      message(moves, :moves)
      message(is_empty, :is_empty)

      scene = scene
      |> morphscene_possible_moves_tag_n_toggle()
      |> morphscene_selected_tag_n_toggle(loc)
      |> morphscene_show_selected_highlight(loc)
      |> morphscene_show_possible_move_highlights(moves)

      {:noreply, scene}
    else
      {:selected_is_mt, true} ->
        # do nothing as selected is empty
        # selected is empty, so don't show selected signifier, set selected to unselected
        # ..... todo fix below
        # selected square is empty, so no possible moves
        scene = scene
        |> morphscene_selected_tag_n_toggle_reset()
        |> morphscene_move_to_tag_n_toggle_reset()
        |> morphscene_remove_possible_moves_highlight()
        |> morphscene_remove_selected_highlight()

        {:noreply, scene}

      {:show_possible_moves_on, false} ->
        # update selected, change toggles, show selected
        # show only the selected signifier on Selected location
        scene = scene
        |> morphscene_possible_moves_tag_n_toggle()
        |> morphscene_selected_tag_n_toggle(loc)
        |> morphscene_show_selected_highlight(loc)

        {:noreply, scene}
    end
  end

  # if the selected to new_click is not a valid possible move
  #     * set selected to unselected, change toggles, remove shown possible moves, remove shown selected
  # if the selected to new_click is a valid possible move (part of the existing possible moves from the selected)
  #     * if send_it_toggle is checked
  #           + make the move in the Board model and set selected to unselected, change toggles, remove shown possible moves, remove shown selected and render the new_board
  #     * if send_it_toggle is not checked
  #           + set new_click to show_highlight move_to, update move_to toggle

  @doc """
  Given a scene and a new_board, morphs the scene to include the board (no validation checks on board),
  unselects origin and destination and promote_type, and removes possible move highlights, and updates the game
  """
  def send_valid_move(scene, new_game) do
    scene
    |> unselect_origin()
    |> unselect_destination()
    |> unselect_promote_type()
    |> morphscene_remove_possible_moves_highlight()
    |> morphscene_replace_game(new_game)
    |> morphscene_if_over_show_endscreen()
  end

  def send_valid_promotion_move(scene, new_game) do
    scene
    |> send_valid_move(new_game)
    |> morphscene_hide_promote_options()
    |> morphscene_if_over_show_endscreen()
  end

  def morphscene_hide_promote_options(%{assigns: %{graph: graph}} = scene) do
    graph = graph
    |> Graph.modify(:promote_rook, &update_opts(&1, hidden: :true))
    |> Graph.modify(:promote_bishop, &update_opts(&1, hidden: :true))
    |> Graph.modify(:promote_knight, &update_opts(&1, hidden: :true))
    |> Graph.modify(:promote_queen, &update_opts(&1, hidden: :true))


    morphscene(scene, graph)
  end

  def unselect_promote_type(scene) do
    scene
    |> morphscene_remove_promote_type_highlight()
    |> morphscene_promote_type_tag_n_toggle_reset()
  end

  def morphscene_remove_promote_type_highlight(%{assigns: %{graph: graph}} = scene) do
    morphscene(scene, Graph.delete(graph, :promote_type_highlight))
  end

  def morphscene_promote_type_tag_n_toggle_reset(%{assigns: %{graph: graph}} = scene) do
    graph = graph
    |> Graph.modify(:promote_type_tag, &text(&1, "UNSELECTED"))
    |> Graph.modify(:promote_type_toggle, &toggle(&1, false))

    morphscene(scene, graph)
  end

  @doc """
  Given a scene and a new_game, morph the scene so the new_game replaces the existing game
  """
  def morphscene_replace_game(%{assigns: %{graph: graph}} = scene, new_game) do
    new_graph = graph
    |> render_game(new_game)

    scene
    |> morphscene_game(new_game)
    |> morphscene(new_graph)
  end

  def morphscene_show_move_to_highlight(%{assigns: %{graph: graph, game: game}} = scene, loc) do
    move_to_translate = loc
    |> location_to_button()
    |> board_sc_loc()
    |> adjust_xy()

    color = location_to_color(game.board.placements, loc) |> grab_current_color(graph)

    move_to_spec = circle_spec(8, fill: color, t: move_to_translate, id: :move_to)

    new_graph = graph
    |> add_specs_to_graph([move_to_spec])

    morphscene(scene, new_graph)
  end

  def morphscene_show_selected_highlight(%{assigns: %{graph: graph, game: game}} = scene, loc) do
    selected_translate = loc
    |> location_to_button()
    |> board_sc_loc()
    |> adjust_xy()

    color = location_to_color(game.board.placements, loc) |> grab_current_color(graph)

    selected_spec = triangle_spec({{0, 0}, {20, 30}, {20, 10}}, fill: color, t: selected_translate, id: :selected)

    new_graph = graph
    |> add_specs_to_graph([selected_spec])

    morphscene(scene, new_graph)
  end

  @doc """
  Given scene (with a graph) and a list of moves, show the possible moves as highlights on the board
  """
  def morphscene_show_possible_move_highlights(%{assigns: %{graph: graph, game: _game}} = scene, moves) do
    message(moves, :the_moves, IO.ANSI.magenta())
    end_loc_specs = for {_start_loc, end_loc} = move <- moves do
      message(move)
      location_to_button(end_loc)
    end
    |> Enum.uniq()
    |> Enum.map(&(&1 |> board_sc_loc() |> adjust_xy()))
    |> Enum.map(&(rect_spec({20, 20}, fill: :red, t: &1, id: :possible_moves)))
    # |> Enum.map(&(circle_spec(50, fill: :red, t: &1, id: :possible_moves)))

    promoting_end_loc_specs = for {_start_loc, end_loc, _promote_type} = _move <- moves do
      location_to_button(end_loc)
    end
    |> Enum.uniq()
    |> Enum.map(&(&1 |> board_sc_loc() |> adjust_xy()))
    |> Enum.map(&(rect_spec({20, 20}, fill: :crimson, t: &1, id: :possible_moves)))

    graph = graph
    |> add_specs_to_graph(end_loc_specs)
    |> add_specs_to_graph(promoting_end_loc_specs)
    # |> Enum.map(&(circle_spec(50, fill: :red, t: &1, id: :possible_moves)))

    morphscene(scene, graph)
  end

  @doc """
  Given a placements 2D list and a location tuple,
  """
  def location_to_color(placements, loc) when is_list(placements) and is_tuple(loc) do
    case Chessboard.get_at(placements, loc) do
      :mt -> :mt
      {color, _type} -> color
    end
  end

  @doc """
  Given a player color (orang or blue) return the translation of that player color, first or second
  """
  def color_to_player_ordered(:orange), do: :first
  def color_to_player_ordered(:blue), do: :second

  @doc """
  Given a player_color (:orange or :blue) or :mt, return the current color in the given graph to display for that color, or black if mt
  """
  def grab_current_color(:mt, _graph) do
    :black
  end

  def grab_current_color(color, graph) do
    id = color_to_player_ordered(color) |> Atom.to_string() |> Kernel.<>("_color_dropdown") |> String.to_existing_atom()

    [%{data: {Scenic.Component.Input.Dropdown, {_dropdown_list, dropdown_starting_value} = _whole_dropdown, _string_hash}  = _dropdown_object, styles: styles}] = Scenic.Graph.get(graph, id)

    case styles do
      map when map == %{} -> dropdown_starting_value
      _any ->
        %{fill: color_tuple} = styles

        color_tuple
    end
  end

  def morphscene_show_possible_moves_of_turn_highlights(%{assigns: %{graph: graph, game: game}} = scene) do
    moves = Chessboard.possible_moves_of_color(game.board, game.turn)
    message(moves, :moves)

    start_loc_specs = for {start_loc, _end_loc} <- moves do
      {location_to_button(start_loc), location_to_color(game.board.placements, start_loc) |> grab_current_color(graph)}
    end
    |> Enum.uniq()
    |> Enum.map(fn {button, color} -> {button |> board_sc_loc() |> adjust_xy(), color} end)
    |> Enum.map(fn {translate, color} -> triangle_spec({{0, 0}, {20, 30}, {20, 10}}, fill: color, t: translate, id: :possible_moves) end)

    end_loc_specs = for {_start_loc, end_loc} = _move <- moves do
      {location_to_button(end_loc), location_to_color(game.board.placements, end_loc) |> grab_current_color(graph)}
    end
    |> Enum.uniq()
    |> Enum.map(fn {button, color} -> {button |> board_sc_loc() |> adjust_xy(), color} end)
    |> Enum.map(fn {translate, color} -> rect_spec({20, 20}, fill: color, t: translate, id: :possible_moves) end)

    graph = graph
    |> add_specs_to_graph(start_loc_specs)
    |> add_specs_to_graph(end_loc_specs)

    morphscene(scene, graph)
  end

  def morphscene_remove_selected_highlight(%{assigns: %{graph: graph}} = scene) do
    graph = graph |> Graph.delete(:selected)

    morphscene(scene, graph)
  end

  def morphscene_remove_possible_moves_highlight(%{assigns: %{graph: graph}} = scene) do
    graph = graph |> Graph.delete(:possible_moves)

    morphscene(scene, graph)
  end

  def morphscene_remove_move_to_highlight(%{assigns: %{graph: graph}} = scene) do
    graph = graph |> Graph.delete(:move_to)

    morphscene(scene, graph)
  end

  def morphscene_possible_moves_tag_n_toggle(%{assigns: %{graph: graph}} = scene) do
    graph = graph
    |> Graph.modify(:possible_moves_tag, &text(&1, "Possible Moves: " <> (Enum.random(0..200) |> Integer.to_string()) <> "#{inspect(true)}"))
    |> Graph.modify(:possible_moves_toggle, &toggle(&1, true))

    morphscene(scene, graph)
  end
  def morphscene_possible_moves_tag_n_toggle_reset(%{assigns: %{graph: graph}} = scene) do
    graph = graph
    |> Graph.modify(:possible_moves_tag, &text(&1, "Possible Moves: " <> (Enum.random(0..200) |> Integer.to_string()) <> "#{inspect(false)}"))
    |> Graph.modify(:possible_moves_toggle, &toggle(&1, false))

    morphscene(scene, graph)
  end

  def morphscene_selected_tag_n_toggle(%{assigns: %{graph: graph}} = scene, selected_loc) do
    graph = graph
    |> Graph.modify(:selected_toggle, &toggle(&1, true))
    |> Graph.modify(:selected_tag, &text(&1, "Selected: " <> "#{selected_loc |> location_to_button()}"))

    morphscene(scene, graph)
  end

  def morphscene_selected_tag_n_toggle_reset(%{assigns: %{graph: graph}} = scene) do
    graph = graph
    |> Graph.modify(:selected_toggle, &toggle(&1, false))
    |> Graph.modify(:selected_tag, &text(&1, "UNSELECTED"))

    morphscene(scene, graph)
  end

  def morphscene_move_to_tag_n_toggle(%{assigns: %{graph: graph}} = scene, move_to_loc) do
    graph = graph
    |> Graph.modify(:move_to_toggle, &toggle(&1, true))
    |> Graph.modify(:move_to_tag, &text(&1, "Moving To: " <> "#{move_to_loc |> location_to_button()}"))

    morphscene(scene, graph)
  end

  def morphscene_move_to_tag_n_toggle_reset(%{assigns: %{graph: graph}} = scene) do
    graph = graph
    |> Graph.modify(:move_to_toggle, &toggle(&1, false))
    |> Graph.modify(:move_to_tag, &text(&1, "UNSELECTED"))

    morphscene(scene, graph)
  end

  def morphscene(scene, new_graph) do
    scene
    |> assign(graph: new_graph)
    |> push_graph(new_graph)
  end

  def morphscene_game(scene, new_game) do
    scene
    |> assign(game: new_game)
  end

  # _----------------_---------------_-----------------_------------------


  def is_origin_selected?(graph) do
    selected_tag = grab_text_value(graph, :selected_tag)

    selected_tag != "UNSELECTED"
  end

  def is_destination_selected?(graph) do
    dest_tag = grab_text_value(graph, :move_to_tag)

    dest_tag != "UNSELECTED"
  end

  def grab_text_value(graph, id) do
    [%{data: text_value}] = Scenic.Graph.get(graph, id)

    text_value
  end

  def show_moves?(%{assigns: %{graph: graph}} = _scene) do
    grab_toggle_value(graph, :possible_moves_toggle)
  end

  def send_it?(%{assigns: %{graph: graph}}) do
    grab_toggle_value(graph, :send_it_toggle)
  end

  def board_sc_loc({col, row}) do
    int_col = Board.Utils.column_to_int(col)
    row = rem(rem(row, 8) - 8, 8) * -1
    {int_col * @col + @x_buf, row * @row + @y_buf}
  end

  # def board_sc_loc("UNSELECTED") do
  #   "NONE"
  # end

  def board_sc_loc(button_atom) when button_atom |> is_atom() do
    button_atom
    |> button_to_location()
    |> board_sc_loc()
  end

  def adjust_xy({x, y}) do
    {x, y + @start_y + @y_buf}
  end

  def adjust_start_xy({x, y}) do
    {x  - @start_x * 2 + 10, y + 25}
  end


  def shorten_button_atom(button) when button |> is_atom() do
    button
    |> Atom.to_string()
    |> String.slice(0..1)
  end

  def shorten_button_atom("UNSELECTED") do
    "NONE"
  end

  def shorten_button_atom("Selected: " <> selected_val) do
    selected_val
    |> String.slice(0..1)
  end

  def shorten_button_atom("Moving To: " <> move_to_val) do
    move_to_val
    |> String.slice(0..1)
  end

  def selected_tag_to_location("Selected: " <> selected_val) do
    selected_val
    |> String.slice(0..1)
    |> String.split("", trim: true)
    |> Enum.map(&(if String.capitalize(&1) != &1, do: &1 |> String.to_existing_atom(), else: &1 |> String.to_integer()))
    |> List.to_tuple()
  end

  def selected_tag_to_location("Moving To: " <> move_to_val) do
    move_to_val
    |> String.slice(0..1)
    |> String.split("", trim: true)
    |> Enum.map(&(if String.capitalize(&1) != &1, do: &1 |> String.to_existing_atom(), else: &1 |> String.to_integer()))
    |> List.to_tuple()
  end

  def selected_tag_to_location("UNSELECTED") do
    "NONE"
  end

  def button_to_location("UNSELECTED") do
    "NONE"
  end

  def button_to_location(button) do
    button
    |> to_string()
    |> String.slice(0..1)
    |> String.split("", trim: true)
    |> Enum.map(&(if String.capitalize(&1) != &1, do: &1 |> String.to_existing_atom(), else: &1 |> String.to_integer()))
    |> List.to_tuple()
  end

  def location_to_button({col_atom, row_int} = _location) do

    ((col_atom |> Atom.to_string()) <> (row_int |> Integer.to_string()) <> ("_button"))
    |> String.to_existing_atom()
  end

  def grab_2nd_in_thruple({_one, two, _three}), do: two
  def grab_toggle_value(graph, id) do
    [%{data: {Scenic.Component.Input.Toggle, value, _rando_string} = _toggle}] = Scenic.Graph.get(graph, id)

    value
  end

  def grab_scenic_primitive(graph, id) do
    Scenic.Graph.get!(graph, id)
  end

  def is_promote_type_chosen?(graph) do
    case grab_text_value(graph, :promote_type_tag) do
      "UNSELECTED" -> false
      any when any in @promote_type_options -> true
      other -> raise ArgumentError, message: "promote_type invalid: #{inspect other}"
    end
  end


  # def grab_unsafe_from_scene(scene, id) do
  #   Scenic.Scene.get_child(scene, id) |> List.first()
  # end

    # -----------------------------------------------------------------------
  # IO puts side effect buttons


    # -------------------------------------

    def handling_send_move() do

    end

    def evaluate_each_promote_option_for_move(board, start_loc, end_loc, color, :pawn) do
      @promote_type_options
      |> Enum.map(&({&1, move(board, start_loc, end_loc, color, :pawn, &1)}))
      |> Enum.filter(fn
        {_promote_to, {:error, _msg}} -> false
        {_promote_to, {:ok, _board}} -> true
      end)
      |> Enum.map(fn {promote_to, {:ok, _board}} -> promote_to end)
    end

    @doc """
    Given the scene, prompt the user for a promote type, blocking the view of the board, but only show
    the promote types that are available
    """
    def display_occluding_promote_options(scene, board, start_loc, end_loc, color, :pawn) do
      real_options = evaluate_each_promote_option_for_move(board, start_loc, end_loc, color, :pawn)

      message("#{inspect @promote_type_options}", :total_options)

      message("#{inspect real_options}", :real_options)

      scene
      |> morphscene_occluding_box()
      |> morphscene_promoting_options(real_options)
    end

    @doc """
    given a scene, morphs it so that an occluding box covers everything
    """
    def morphscene_occluding_box(%{assigns: %{graph: graph}} = scene) do
      new_graph = graph |> Graph.modify(:occluding_box, &update_opts(&1, hidden: false))
      morphscene(scene, new_graph)
    end

    @doc """
    Given a scene, morphs it so promoting options are displayed on the screen kind of centrally
    """
    def morphscene_promoting_options(%{assigns: %{graph: graph}} = scene, real_options) do
      r_graph = if :rook in real_options do
        graph |> Graph.modify(:promote_rook, &button(&1, "Rook", t: {0, 0}, hidden: :false))
      else
        graph
      end

      k_graph = if :knight in real_options do
        r_graph |> Graph.modify(:promote_knight, &button(&1, "Knight", t: {0, 30}, hidden: :false))
      else
        r_graph
      end

      b_graph = if :bishop in real_options do
        k_graph |> Graph.modify(:promote_bishop, &button(&1, "Bishop", t: {0, 60}, hidden: :false))
      else
        k_graph
      end

      q_graph = if :queen in real_options do
        b_graph |> Graph.modify(:promote_queen, &button(&1, "Queen", t: {0, 90}, hidden: :false))
      else
        b_graph
      end

      morphscene(scene, q_graph)
    end

    @doc """
    Given a game and a new_board, progress the game dumbly, so turn is cycled to the other color and the given board is subbed in
    """
    def progress_game(game, new_board) do
      %{game | board: new_board, turn: game.turn |> otherColor()}
    end

    def morphscene_if_over_show_endscreen(%{assigns: %{graph: _graph, game: game}} = scene) do
      if GameRunner.isOver(game) do
        message("GAMEOVER", :gameover, IO.ANSI.black(), IO.ANSI.red_background())

        scene = cond do
          GameRunner.isDrawn(game, game.turn) ->
            message("DRAWN", :resolution, IO.ANSI.light_red)
            morphscene_render_gray_lines_over_both_kings(scene)

          GameRunner.isLost(game, game.turn) ->
            message("LOST", :resolution, IO.ANSI.light_red)
            morphscene_render_red_x_over_losing_king(scene)

          GameRunner.isWon(game, game.turn) ->
            message("WON", :resolution, IO.ANSI.light_red)
            morphscene_render_red_x_over_losing_king(scene)
        end

        scene
        |> morphscene_occluding_box()
        |> morphscene_gameover_buttons()
      else
        scene
      end
    end

    def morphscene_gameover_buttons(scene) do
      scene
    end

    def morphscene_render_red_x_over_losing_king(scene) do
      scene
    end

    def morphscene_render_gray_lines_over_both_kings(scene) do
      scene
    end

    @doc """
    Given a graph, grabs the promote type tag from it
    """
    def grab_promote_type(graph) do
      grab_text_value(graph, :promote_type_tag)
    end

    # move is not valid, unselect, show message, unshow possible_moves
    @doc """
    Given a scene, write a msg to stdout saying a move was sent but failed, and unelect the origin, destination,
    and remove all possible move highlights
    """
    def send_invalid_move(scene, start_loc, end_loc, msg, promote_type \\ :nopromote) do
      message("#{inspect(start_loc)} to #{inspect(end_loc)} failed, promote: #{promote_type} #{msg}", :sent_an_invalid_move, IO.ANSI.red())
      scene
      |> unselect_origin()
      |> unselect_destination()
      |> unselect_promote_type()
      |> morphscene_remove_possible_moves_highlight()
    end

    @doc """
    Given a string, an id (the label) and an optional text_color and default (IO.ANSI.<etc>),
    writes the colors to stdout and inspects the string with the label
    """
    def message(string, id \\ nil, text_color \\ IO.ANSI.default_color(), background_color \\ IO.ANSI.default_background()) do
      IO.write(text_color)
      IO.write(background_color)
      case id do
        nil -> IO.inspect(string)
        any when any |> is_atom() -> IO.inspect(string, label: id)
      end
    end

    @doc """
    Given a scene, select the destination point (end_loc) on the scene, render it and change the relevant tags n toggles
    """
    def select_destination(scene, loc) do
      scene
      |> morphscene_show_move_to_highlight(loc)
      |> morphscene_move_to_tag_n_toggle(loc)
    end

    @doc """
    Given a scene, remove any destination (end_loc) highlights and set toggles n tags to empty/false
    """
    def unselect_destination(scene) do
      scene
      |> morphscene_remove_move_to_highlight()
      |> morphscene_move_to_tag_n_toggle_reset()
    end

    @doc """
    Given a scene, remove any origin (start_loc) highlights and set toggles n tags to empty/false
    """
    def unselect_origin(scene) do
      scene
      |> morphscene_remove_selected_highlight()
      |> morphscene_selected_tag_n_toggle_reset()
    end

    @doc """
    Given a scene, select the origin point (start_loc) on the scene, render it and change the relevant tags n toggles
    """
    def select_origin(scene, loc) do
      scene
      |> morphscene_selected_tag_n_toggle(loc)
      |> morphscene_show_selected_highlight(loc)
    end

    @doc """
    Given a graph and an id, grabs the value of the text Tag with that id in the graph
    """
    def grab_tag_value(graph, id) do
      [%{data: value_of_id}] = Scenic.Graph.get(graph, id)
      value_of_id
    end
    # -------------------------------------------------------------------------
    # scale slider


  @doc """
  Given an event (tuple of click, dropdown etc), somethingelse, and an existing scene,
  handle each event to do the things required to progress the chess game in the direction indicated by
  the user-imparted click
  """
  @impl Scenic.Scene
  def handle_event({:click, :settings}, _, scene) do
    IO.puts("#{IO.ANSI.yellow}#{IO.ANSI.default_background}Clicked Settings__________-")

    {:noreply, scene}
  end

  def handle_event({:click, :show_game}, _, %{assigns: %{game: game}} = scene) do
    IO.puts("#{IO.ANSI.default_color}#{IO.ANSI.default_background}Clicked Show Game.")

    message(game, :current_game)

    {:noreply, scene}
  end

  def handle_event({:click, :send_it}, _, %{assigns: %{graph: graph, game: game}} = scene) do
    IO.puts("#{IO.ANSI.green}#{IO.ANSI.black_background}Clicked Send IT !!!")

    if graph |> is_origin_selected?() do
      # origin already selected, so origin is start_loc, clicked is end_loc
      start_loc = grab_text_value(graph, :selected_tag) |> selected_tag_to_location()

      if graph |> is_destination_selected?() do
        # destination is selected too (can't select without validating)!
        end_loc = grab_text_value(graph, :move_to_tag) |> selected_tag_to_location()

        {piece_color, piece_type} = _moving_piece = Chessboard.get_at(game.board.placements, start_loc)
        # game.turn not piece_color
        message("{#{piece_color}, #{piece_type}}", :moving_piece, IO.ANSI.green())

        if Chessboard.move_requires_promotion?(game.turn, piece_type, end_loc) do
          # move requires promotion
          if graph |> is_promote_type_chosen?() do
            # promoting to is chosen
            promote_type = grab_promote_type(graph)

            case Chessboard.move(game.board, start_loc, end_loc, game.turn, piece_type, promote_type) do
              {:ok, new_board} ->
                # promoting move is valid, send the move
                new_game = progress_game(game, new_board)

                message(new_game, :new_game)

                scene = send_valid_move(scene, new_game)
                {:noreply, scene}

              {:error, msg} ->
                # promoting move is invalid, show error message
                message("Trying to send a move, origin is selected #{start_loc} and destination is selected #{end_loc}, and promote_type is selected #{promote_type}, but move is invalid.")
                scene = scene
                |> send_invalid_move(start_loc, end_loc, msg, promote_type)
                |> unselect_promote_type()
                {:noreply, scene}
            end
          else
            # promoting to is not chosen
            message("Trying to send a move which requires promotion, origin is selected #{start_loc} and destination is selected #{end_loc}, but promote_type is not chosen.")
            {:noreply, scene}
          end
        else
          # move does not require promotion
          case Chessboard.move(game.board, start_loc, end_loc, game.turn, piece_type, :nopromote) do
            {:ok, new_board} ->
              # move is valid, send the move
              new_game = progress_game(game, new_board)
              message(new_game, :new_game)
              scene = send_valid_move(scene, new_game)
              {:noreply, scene}

            {:error, msg} ->
              # move is not valid, unselect all, raise error?
              scene = scene |> send_invalid_move(start_loc, end_loc, msg)

              {:noreply, scene}
          end
        end
      else
        # destination is not selected
        message("Trying to send a move, origin is selected #{inspect start_loc} but destination is not")
        {:noreply, scene}
      end
    else
      # nothing selected
      message("Trying to send a move but nothing is selected")
      {:noreply, scene}
    end
  end

  # Handle Possible Moves button click by showing possible moves of selected, mt indicator, or possible moves of whoever's turn it is
  def handle_event({:click, :possible_moves_button}, _, %{assigns: %{graph: graph, game: game}} = scene) do
    IO.puts("#{IO.ANSI.yellow}#{IO.ANSI.blue_background}CLICKED possible moves button")
    # show_possible_moves_bool = grab_toggle_value(graph, :possible_moves_toggle)
    # show selected indicator
    selected_tag = grab_tag_value(graph, :selected_tag)
    start_loc = selected_tag_to_location(selected_tag)

    message(start_loc, :start_loc)

    with {:is_selected, true} <- {:is_selected, graph |> is_origin_selected?()},
         {:selected_is_mt, false} <- {:selected_is_mt, Chessboard.get_at(game.board.placements, start_loc) == :mt} do
      # then show possible moves of selected square (which is not empty)
      moves = Chessboard.possible_moves(game.board, start_loc)
      is_empty = moves == []
      message(start_loc, :start_loc)
      message(Chessboard.get_at(game.board.placements, start_loc), :piece_at_start_loc)
      message(moves, :moves)
      message(is_empty, :is_empty)

      scene = scene
      |> morphscene_possible_moves_tag_n_toggle()
      |> morphscene_selected_tag_n_toggle(start_loc)
      |> morphscene_show_possible_move_highlights(moves)
      |> morphscene_show_selected_highlight(start_loc)

      {:noreply, scene}
    else
      {:is_selected, false} ->
        # show all possible moves of all pieces of the side whose turn it is
        message(Chessboard.threatens(game.board, game.turn), :threatens)
        scene = scene
        |> morphscene_possible_moves_tag_n_toggle()
        |> morphscene_show_possible_moves_of_turn_highlights()

        {:noreply, scene}

      {:selected_is_mt, true} ->
        # selected is empty, so show selected mt signifier, no possible moves
        scene = scene
        |> morphscene_possible_moves_tag_n_toggle()
        #|> morphscene_show_selected_mt_highlight()

        {:noreply, scene}
    end
  end


  def handle_event({:click, :promote_rook}, _, scene) do
    gather_all_move_data_for_promotion(:rook, scene)
  end

  def handle_event({:click, :promote_knight}, _, scene) do
    gather_all_move_data_for_promotion(:knight, scene)
  end

  def handle_event({:click, :promote_bishop}, _, scene) do
    gather_all_move_data_for_promotion(:bishop, scene)
  end

  def handle_event({:click, :promote_queen}, _, scene) do
    gather_all_move_data_for_promotion(:queen, scene)
  end

  def gather_all_move_data_for_promotion(promote_type, %{assigns: %{graph: graph, game: game}} = scene) do
    message("promote #{inspect promote_type}", :clicked, IO.ANSI.green(), IO.ANSI.default_background())
    # show selected indicator
    selected_tag = grab_tag_value(graph, :selected_tag)
    destination_tag = grab_tag_value(graph, :move_to_tag)

    start_loc = selected_tag |> selected_tag_to_location()
    end_loc = destination_tag |> selected_tag_to_location()
    {piece_color, piece_type} = Chessboard.get_at(game.board.placements, start_loc)

    message("{#{piece_color}, #{piece_type}}", :moving_piece, IO.ANSI.green())

    handle_move_promote_type_chosen(scene, game, start_loc, end_loc, piece_type, promote_type)
  end


  @doc """
  Given a scene, a game, and information for a move including promote_type, handle
  that move for the given scene
  """
  def handle_move_promote_type_chosen(scene, game, start_loc, end_loc, piece_type, promote_type) do
    if scene |> send_it?() do
      # send_it is toggled on
      case Chessboard.move(game.board, start_loc, end_loc, game.turn, piece_type, promote_type) do
        {:ok, new_board} ->
          # move is valid, send that shcnat!
          new_game = progress_game(game, new_board)
          scene = scene
          |> send_valid_promotion_move(new_game)

          {:noreply, scene}

        {:error, msg} ->
          # move is invalid???? unselectall, unshow possible moves
          scene = send_invalid_move(scene, start_loc, end_loc, msg)
          {:noreply, scene}
      end
    else
      # send_it is toggled off

      # set clicked to moveto (destination) since sendit toggle is off
      # set new_click to show_highlight move_to, update move_to toggle
      # send_it_toggle is false, so simply give it another indicator and change move_to to this value
      scene = scene
      |> morphscene_remove_possible_moves_highlight()

      {res, _content} = Chessboard.move(game.board, start_loc, end_loc, game.turn, piece_type, promote_type)

      if res == :ok do
        # move is valid, set moveto to clicked
        scene = select_destination(scene, end_loc)

        {:noreply, scene}
      else
        # move is invalid, unselect
        scene = scene |> unselect_origin()

        {:noreply, scene}
      end
    end
  end

  # handles a click event on the Board,
  #  if selected is not set: (attempt show_possible_moves)
  #     - if new_click is mt
  #          * do nothing
  #     - if new_click is a piece
  #          * if show_possible_moves is on
  #                + set selected to new_click, change toggles, show possible moves, show selected
  #          * if show_possible_moves is off
  #                + set selected to new_click, change toggles, show selected
  #  if selected is set: (attempt send_move)
  #     - if the selected to new_click is not a valid possible move
  #          * set selected to unselected, change toggles, remove shown possible moves, remove shown selected
  #     - if the selected to new_click is a valid possible move (part of the existing possible moves from the selected)
  #          * if send_it_toggle is checked
  #                 + make the move in the Board model and set selected to unselected, change toggles, remove shown possible moves, remove shown selected and render the new_board
  #          * if send_it_toggle is not checked
  #                 + set new_click to show_highlight move_to, update move_to toggle
  def handle_event({:click, button}, _, %{assigns: %{graph: graph, game: game}} = scene) do
    message("#{inspect button}", :clicked, IO.ANSI.green(), IO.ANSI.default_background())
    # show selected indicator
    selected_tag = grab_tag_value(graph, :selected_tag)
    clicked_loc = button_to_location(button)

    if graph |> is_origin_selected?() do
      # already a selected, so selected is start_loc, clicked is end_loc
      start_loc = selected_tag |> selected_tag_to_location()
      end_loc = button |> button_to_location()
      {piece_color, piece_type} = Chessboard.get_at(game.board.placements, start_loc)

      message("{#{piece_color}, #{piece_type}}", :moving_piece, IO.ANSI.green())

      if is_promote_type_chosen?(graph) do
        # promote type is chosen, so we have all the info we need to proceed
        promote_type = grab_promote_type(graph)

        handle_move_promote_type_chosen(scene, game, start_loc, end_loc, piece_type, promote_type)
      else
        # promote type is not chosen
        # so we need to prompt for the promote type (BETWEEN moves kind of), so like an alert in the browser

        message("1", :one, IO.ANSI.light_yellow)
        if Chessboard.move_requires_promotion?(game.turn, piece_type, end_loc) do
          # move requires promotion
          message("2", :two, IO.ANSI.light_yellow)

          if at_least_one_promote_valid(game.board, start_loc, end_loc, game.turn, piece_type) do
            # there is a valid promote type
            message("3", :three, IO.ANSI.light_yellow)

            scene = scene
            |> morphscene_move_to_tag_n_toggle(end_loc)
            |> display_occluding_promote_options(game.board, start_loc, end_loc, game.turn, piece_type)
            {:noreply, scene}
          else
            # no promote valid
            message("3a", :three_a, IO.ANSI.light_yellow)

            send_invalid_move(scene, start_loc, end_loc, "no promote type valid", :queen)
            {:noreply, scene}
          end
        else
          # move does not require promotion
          message("4", :four, IO.ANSI.light_yellow)

          promote_type = :nopromote

          if scene |> send_it?() do
            # send_it is toggled on
            message("5", :five, IO.ANSI.light_yellow)

            case Chessboard.move(game.board, start_loc, end_loc, game.turn, piece_type, promote_type) do
              {:ok, new_board} ->
                # move is valid, send that shcnat!
                message("6", :six, IO.ANSI.light_yellow)

                new_game = progress_game(game, new_board)
                scene = send_valid_move(scene, new_game)
                {:noreply, scene}

              {:error, msg} ->
                message("7", :seven, IO.ANSI.light_yellow)

                # move is invalid???? unselectall, unshow possible moves
                scene = send_invalid_move(scene, start_loc, end_loc, msg)
                {:noreply, scene}
            end
          else
            # send_it is toggled off

            # set clicked to moveto (destination) since sendit toggle is off
            # set new_click to show_highlight move_to, update move_to toggle
            # send_it_toggle is false, so simply give it another indicator and change move_to to this value
            scene = scene
            |> morphscene_remove_possible_moves_highlight()

            {res, _content} = Chessboard.move(game.board, start_loc, end_loc, game.turn, piece_type, promote_type)

            if res == :ok do
              # move is valid, set moveto to clicked
              scene = select_destination(scene, end_loc)

              {:noreply, scene}
            else
              # move is invalid, unselect
              scene = scene |> unselect_origin()

              {:noreply, scene}
            end
          end
        end
      end
    else
      # Nothing selected, so try to select clicked

      if Chessboard.get_at(game.board.placements, clicked_loc) == :mt do
        # clicked is empty
        # do nothing
        # selected square is empty, so no possible moves,
        # remove possible moves highlight in case the possible moves for all pieces was on
        # could do unselect origin and destination, but no need
        scene = scene
        |> morphscene_remove_possible_moves_highlight()

        {:noreply, scene}
      else
        # clicked has a piece on it, so we select
        selected_scene = select_origin(scene, clicked_loc)

        if selected_scene |> show_moves?() do
          # toggled on so show them moves
          moves = Chessboard.possible_moves(game.board, clicked_loc)

          selected_scene = selected_scene
          |> morphscene_show_possible_move_highlights(moves)

          {:noreply, selected_scene}
        else
          # don't show them moves
          {:noreply, selected_scene}
        end
      end
    end
  end

  def handle_event({:value_changed, :scale, scale}, _, %{assigns: %{graph: graph}} = scene) do
    graph = Graph.modify(graph, :whole_board, &update_opts(&1, scale: scale))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:halt, scene}
  end

  # ---------------------------------------------------------------------
  # toggle controls

  def at_least_one_promote_valid(board, start_loc, end_loc, color, :pawn) do
    thing = @promote_type_options
    |> Enum.any?(&(Chessboard.move(board, start_loc, end_loc, color, :pawn, &1) |> okify()))
    message("#{inspect thing}", :promote_type_validity)
    thing
  end

  @spec okify({:error, any} | {:ok, any}) :: boolean
  def okify({:ok, _thing}), do: true
  def okify({:error, _msg}), do: false

  # toggle moving
  def handle_event({:value_changed, :moving_toggle, toggle}, _pid, %{assigns: %{graph: graph}} = scene) do
    graph = Graph.modify(graph, :moving_tag, &text(&1, (Enum.random(0..200) |> Integer.to_string()) <> "#{inspect(toggle)}"))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:halt, scene}
  end

  # toggle show_possible_moves
  def handle_event({:value_changed, :possible_moves_toggle, toggle} = _event, _, %{assigns: %{graph: graph}} = scene) do
    graph = Graph.modify(graph, :possible_moves_tag, &text(&1, (Enum.random(0..200) |> Integer.to_string()) <> "#{inspect(toggle)}"))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:halt, scene}
  end

  # -----------------------------------------------------------------
  # color controls

  # when the color picker color changes, change every first color id to that color with fill
  def handle_event({:value_changed, :first_color_dropdown, new_color}, _, %{assigns: %{graph: graph, game: game}} = scene) do
    graph = Graph.modify(graph, :first_color_dropdown, &update_opts(&1, fill: new_color))
    |> Graph.modify(:first_color_label, &text(&1, inspect(new_color)))
    |> render_game(game)

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:halt, scene}
  end

  # when the color picker color changes, change every first color id to that color with fill
  def handle_event({:value_changed, :second_color_dropdown, new_color}, _, %{assigns: %{graph: graph, game: game}} = scene) do
    graph = Graph.modify(graph, :second_color_dropdown, &update_opts(&1, fill: new_color))
    |> Graph.modify(:second_color_label, &text(&1, inspect(new_color)))
    |> render_game(game)

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

  # ---------------------------------------------

  # handle the rest of the stuff and log the event and pid
  def handle_event(event, pid, scene) do
    message("#{inspect(event)}", :event)
    message("#{inspect(pid)}", :pid)
    {:halt, scene}
  end
end
