defmodule TCPServerTest do
  @moduledoc """
  Async, Testing the TCPServer
  """
  use ExUnit.Case, async: true

  setup do
    {:ok, serve} = TCPServer.accept(4041)
    %{serve: serve}
    # on_exit(fn -> TCPServer.stop_accepting() end)
  end

  @tag :skip
  test "test timeout" do
    assert true
  end
end
