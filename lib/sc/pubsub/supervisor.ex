# a simple supervisor that starts up the Scenic.SensorPubSub server
# and any set of other sensor processes

defmodule Genomeur.PubSub.Supervisor do
  @moduledoc """
  This is where the supervisor for the chessComputers 'sensor' is
  """
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    [
      # add your data publishers here
      Genomeur.PubSub.ChessComputers
    ]
    |> Supervisor.init(strategy: :one_for_one)
  end
end
