defmodule TCPServerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, serve} = TCPServer.accept(4040)
    %{serve: serve}
  end

  test "greets the world" do
    assert true
  end
end
