defmodule Genomeur.Assets do
  @moduledoc """
  The Assets
  """
  use Scenic.Assets.Static,
  otp_app: :genomeur,
  alias: [
    genomeur_logo_svg: "images/genomeur_logo.svg",
    genomeur_logo_jpg: "images/genomeur_logo.jpg",
    genomeur_logo_png: "images/genomeur_logo.png",

    # # genomechess_logo_svg: "images/genomechess_logo.svg",
    # # genomechess_logo_jpg: "images/genomechess_logo.jpg",
    genomechess_logo_png: "images/genomechess_logo.png",


    owl: "images/owl.jpg",
    lato: "fonts/Lato-Hairline.ttf",
    baloo: "fonts/Baloo-Regular.ttf",
    belligerent: "fonts/belligerent.ttf",
    caviar_dreams: "fonts/CaviarDreams.ttf",
    rubik: "fonts/Rubik-Black.ttf",
    chess_font: "fonts/CHEQ_TT.TTF",
    # roboto2: "fonts/roboto.ttf",
    # roboto_mono2: "fonts/roboto_mono.ttf",
  ]
end
