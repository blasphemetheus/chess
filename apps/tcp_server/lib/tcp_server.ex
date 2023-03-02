defmodule TCPServer do
  @moduledoc """
  Documentation for `TCPServer`.
  """
  require Logger
  # tcp servers:
  # - listen to a port until port is available the server gets hold of the socket
  # - waits for a client connection on that port and accepts it
  # - reads the client request and writes a response back

  def accept(port) do
    # the options below:
    # 1. :binary - receives data as binaries (not lists)
    # 2. packet: :line - receives data line by line
    # 3. active: false - blocks on `:gen_tcp.recv/2` until data is avail
    # 4 reuseaadr: true - allows us to reuse the address if the listener crashes

    {:ok, socket} =
      :gen_tcp.listen(
        port,
        [:binary, packet: :line, active: false, reuseaddr: true]
      )

    Logger.info("Accepting Connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(TCPServer.TaskSupervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    msg =
      with  {:ok, data} <- read_line(socket),
            {:ok, command} <- TCPServer.Command.parse(data),
            do: TCPServer.Command.run(command)
      # case read_line(socket) do
      #  {:ok, data} ->
      #    case TCPServer.Command.parse(data) do
      #      {:ok, command} ->
      #        TCPServer.Command.run(command)
      #      {:error, _} = err ->
      #        err
      #    end
      ##    {:error, _} = err ->
      #      err
      #end
    write_line(socket, msg)
    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, text}) do
    :gen_tcp.send(socket, text)
  end

  defp write_line(socket, {:error, :unknown_command}) do
    # known error; write to the client
    :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    # the connection was closed, exit politely
    exit(:shutdown)
  end

  defp write_line(socket, {:error, error}) do
    #unknown error; write to the client and exit
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end
end
