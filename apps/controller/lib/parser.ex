defmodule Parser do

  @doc """
  given a move in the format {start_lo
  iex> Parser.parseMove("e2 e4")
  {:ok, %{start_loc: {4, 2}, end_loc: {4, 4}, type_at_loc: :pawn}}
  """
  def parseMove(raw_move) do
    ## TODO make evaluate validity not raise error if invalid
    #split = raw_move
    #|> String.splitter([" ", ","])
    #|> Enum.take(2)
    #|> okify()

    #IO.puts("split ver: #{inspect(split)}")

    {_start_loc, _end_loc} = recurred = parse(raw_move, [])
    #|> Enum.split_with(fn x -> intake(x) end)
    |> Enum.reject(&(&1 == :space))
    |> Enum.chunk_every(2)
    |> Enum.map(
      fn
        ls when length(ls) == 1 -> List.first(ls)
        ls when ls |> is_list() -> ls |> List.to_tuple()
      end)
    |> intake()
    #|> assign_keys()
    |> okify()

    IO.puts("recursive version: #{inspect(recurred)}")

    recurred


    # parse the move
    # if valid, return the start_loc, end_loc, and type_at_loc
    # if invalid, return false
  end

  #def assign_keys([first | [second | []]]) do
  ##  %{start_loc: first, end_loc: second, type_at_loc: :pawn}
  #e#nd

  @doc """
  Given a list of codepoints of the format [:a], converts to tuple
  """
  def intake([first | [second | ["KNIGHT"]]]), do: {first, second, :knight}
  def intake([first | [second | ["ROOK"]]]), do: {first, second, :rook}
  def intake([first | [second | ["BISHOP"]]]), do: {first, second, :bishop}
  def intake([first | [second | ["QUEEN"]]]), do: {first, second, :queen}
  def intake([first | [second | ["KING"]]]), do: {first, second, :king}
  def intake([first | [second | ["PAWN"]]]), do: {first, second, :pawn}
  def intake([first | [second | []]]), do: {first, second, :pawn}

  # for promotion
  def intake([first | [second | [{"PAWN", piece}]]]), do: {first, second, :pawn, String.to_atom(piece)}

  # for castling
  def intake([first | [second | [{"KING", "CASTLE"}]]]), do: {first, second, :pawn, :castle}

  def intake([{_col, _row} = only | []]) do
    # so someone tried to input a pawn sprint
    start = inferPawnStartLocation(only)
    {start, only, :pawn}
  end

  def inferPawnStartLocation({col, 4}), do: {col, 2}
  def inferPawnStartLocation({col, 5}), do: {col, 7}
  def inferPawnStartLocation({col, 3}), do: {col, 2}
  def inferPawnStartLocation({col, 6}), do: {col, 7}


  def inferPawnStartLocation(any), do: raise ArgumentError, message: "wrong abbreviated pawn sprint"


  def okify(thing), do: {:ok, thing}

  @doc """
  Given any string, runs through the string recursively byte by byte
  returning the important bits in a list
  NOT THE WAY TO DO IT, BECAUSE WE HAVE STRING.GRAPHEMES which already does that kind of
  """
  def parse("CASTLE" <> rest, acc), do: parse(rest, ["CASTLE" | acc])
  def parse("L" <> rest, acc), do: parse(rest, ["CASTLE" | acc])
  def parse("QUEEN" <> rest, acc), do: parse(rest, ["QUEEN" | acc])
  def parse("Q" <> rest, acc), do: parse(rest, ["QUEEN" | acc])
  def parse("KING" <> rest, acc), do: parse(rest, ["KING" | acc])
  def parse("K" <> rest, acc), do: parse(rest, ["KING" | acc])
  def parse("BISHOP" <> rest, acc), do: parse(rest, ["BISHOP" | acc])
  def parse("O" <> rest, acc), do: parse(rest, ["BISHOP" | acc])
  def parse("KNIGHT" <> rest, acc), do: parse(rest, ["KNIGHT" | acc])
  def parse("N" <> rest, acc), do: parse(rest, ["KNIGHT" | acc])
  def parse("ROOK" <> rest, acc), do: parse(rest, ["ROOK" | acc])
  def parse("R" <> rest, acc), do: parse(rest, ["ROOK" | acc])
  def parse("PAWN" <> rest, acc), do: parse(rest, ["PAWN" | acc])
  def parse("P" <> rest, acc), do: parse(rest, ["PAWN" | acc])

  def parse("A" <> rest, acc), do: parse(:col, rest, [:a | acc])
  def parse("B" <> rest, acc), do: parse(:col, rest, [:b | acc])
  def parse("C" <> rest, acc), do: parse(:col, rest, [:c | acc])
  def parse("D" <> rest, acc), do: parse(:col, rest, [:d | acc])
  def parse("E" <> rest, acc), do: parse(:col, rest, [:e | acc])
  def parse("F" <> rest, acc), do: parse(:col, rest, [:f | acc])
  def parse("G" <> rest, acc), do: parse(:col, rest, [:g | acc])
  def parse("H" <> rest, acc), do: parse(:col, rest, [:h | acc])
  def parse(:col, "1" <> rest, acc), do: parse(rest, [1 | acc])
  def parse(:col, "2" <> rest, acc), do: parse(rest, [2 | acc])
  def parse(:col, "3" <> rest, acc), do: parse(rest, [3 | acc])
  def parse(:col, "4" <> rest, acc), do: parse(rest, [4 | acc])
  def parse(:col, "5" <> rest, acc), do: parse(rest, [5 | acc])
  def parse(:col, "6" <> rest, acc), do: parse(rest, [6 | acc])
  def parse(:col, "7" <> rest, acc), do: parse(rest, [7 | acc])
  def parse(:col, "8" <> rest, acc), do: parse(rest, [8 | acc])
  def parse(" " <> rest, acc), do: parse(rest, [:space | acc])

  def parse("", acc), do: Enum.reverse(acc)

  def parse(<<codepoint>> <> rest, acc) do
    parse(rest, [codepoint | acc])
  end

  def parse(string, acc) do
    next = String.next_grapheme(string)
    bin_size = String.next_grapheme_size(string)
    IO.puts("________")
  end

  ## if ever I need to deal with non-utf8 stuff,
  # String.next_codepoint is real nice

  # prob for my purposes here, String.next_grapheme(str) is prob good enough



end
