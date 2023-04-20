defmodule MockCLIViewPipe do
  def puts(str) do
    str
  end

  # pattern match for tests
  def gets(str) do
    "cazooie"
  end
end
