defmodule MockCLIViewPipe do
  @moduledoc """
  All about Mocking the IO for mocks in test of CLIView
  """
  def puts(str) do
    str
  end

  # pattern match for tests
  def gets(str) do
    "cazooie"
  end
end
