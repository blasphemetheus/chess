defmodule Genomeur.PubSub.ChessComputers do
  @moduledoc """
  This is where the computers actually play chess, like the temperature sensor
  """
  use GenServer
  require GameRunner
  require Player

  alias Scenic.PubSub

  @name :chess_computers
  @version "0.1.1"
  @description "Watch Computers Play Chess Badly"
  @tag "larry"
  @opp_tag "king"
  # @timer_ms 800
  @timer_ms 50
  #GameRunner.createGame(:computer, :computer, @tag, @opp_tag)
  @initial_game %GameRunner{
    board: Chessboard.createBoard(),
    bgame: :chess,
    turn: :orange,
    first: %Player{type: :computer, color: :orange, tag: @tag, lvl: 1},
    second: %Player{type: :computer, color: :blue, tag: @opp_tag, lvl: 1},
    status: :in_progress,
    history: [],
    resolution: nil,
    reason: nil
  }
  #@level 1


  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def init(_) do
    # register the game:
    PubSub.register(:chess_computers, version: @version, description: @description)
    # PubSub.Sensor.register(:action, "1.0", "Action...")

    # put first game value
    PubSub.publish(:chess_computers, @initial_game)

    {:ok, timer} = :timer.send_interval(@timer_ms, :tick)

    {:ok, %{timer: timer, chess_computers: @initial_game, t: 0}}
  end

  # would react to data sent from the other module as a message, but we can also just
  # tell the computers to play a game here, should work
  def handle_info(:tick, %{t: t, chess_computers: old_game} = state) do
    play_turn =
      old_game
      |> GameRunner.playCPUTurn(1, :chess)

    new_game =
      if GameRunner.isOver(play_turn) do
        %{resolution: resolution} = GameRunner.findResolution(play_turn)
        {n_first_tag, n_second_tag} = case resolution do
          :drawn -> newNameDraw(old_game.first.tag, old_game.second.tag)
          :win -> newNameWin(old_game.first.tag, old_game.second.tag)
          :loss -> newNameWin(old_game.second.tag, old_game.first.tag)
        end
        GameRunner.createGame(:computer, :computer, n_first_tag, n_second_tag)
      else
        play_turn
      end

    PubSub.publish(:chess_computers, new_game)

    {:noreply, %{state | chess_computers: new_game, t: t + 1}}
  end

  def newNameWin(winner_name, loser_name) do
    {winner_name <> "W", loser_name <> "L"}
  end

  def newNameDraw(first_drawer, second_drawer) do
    {first_drawer <> "_", second_drawer <> "_"}
  end
end
