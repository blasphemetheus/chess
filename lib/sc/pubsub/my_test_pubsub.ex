defmodule Genomeur.Pubsub.MyTestPubsub do
  use GenServer

  @name "example"
  @description "this is description"
  @version "8"
  @initial_game

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def init(_) do
    # register the game:
    PubSub.register(:chess_computers, version: @version, description: @description)

    # put first game value
    PubSub.publish(:chess_computers, @initial_game)

    {:ok, timer} = :timer.send_interval(@timer_ms, :tick)

    {:ok, %{timer: timer, chess_computers: @initial_game, t: 0}}
  end


end
