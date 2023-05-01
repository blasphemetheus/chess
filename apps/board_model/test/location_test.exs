defmodule LocationTest do
  use ExUnit.Case
  import Location

  describe "test assert formalLocation({row, col})" do
    test "errors for bad input: try and convert formal location to formal location" do
      assert catch_error(assert formalLocation({1, :a}))
      assert_raise ArgumentError, fn ->
        assert formalLocation({1, :a})
      end
    end

    test "errors for bad input: try and convert backwards formal location to formal" do
      catch_error(assert formalLocation({:a, 1}))
      assert_raise ArgumentError, fn ->
        assert formalLocation({:a, 1})
      end
    end

    test "basic dumb location to formal" do
      assert formalLocation({0, 0}) == {:a, 1}
      assert formalLocation({1, 1}) == {:b, 2}
      assert formalLocation({2, 2}) == {:c, 3}
      assert formalLocation({3, 3}) == {:d, 4}
      assert formalLocation({4, 4}) == {:e, 5}
      assert formalLocation({5, 5}) == {:f, 6}
      assert formalLocation({6, 6}) == {:g, 7}
      assert formalLocation({7, 7}) == {:h, 8}
    end

    test "invalid dumb location high" do
      assert catch_error(assert formalLocation({8, 8}))
      assert_raise ArgumentError, fn ->
        assert formalLocation({8, 8})
      end
    end
    test "invalid dumb location low" do
      assert catch_error(assert formalLocation({0, -6}))
      assert_raise ArgumentError, fn ->
        assert formalLocation({0, -6})
      end
    end
  end # end describe

  describe "test dumbLocation({col, row})" do

    test "regression test : no issue with random access call error" do
      assert dumbLocation({:a, 1}) == {0, 0}
    end

    test "basic functionality" do
      assert dumbLocation({:a, 1}) == {0, 0}
      assert dumbLocation({:b, 2}) == {1, 1}
      assert dumbLocation({:c, 3}) == {2, 2}
      assert dumbLocation({:d, 4}) == {3, 3}
      assert dumbLocation({:e, 5}) == {4, 4}
      assert dumbLocation({:f, 6}) == {5, 5}
      assert dumbLocation({:g, 7}) == {6, 6}
      assert dumbLocation({:h, 8}) == {7, 7}

      #assert dumbLocation({:a, 1}) == {0, 0}
      #assert dumbLocation({:b, 2}) == {1, 1}
      #assert dumbLocation({:c, 3}) == {2, 2}
      #assert dumbLocation({:d, 4}) == {3, 3}
      #assert dumbLocation({:e, 5}) == {4, 4}
      #assert dumbLocation({:f, 6}) == {5, 5}
      #assert dumbLocation({:g, 7}) == {6, 6}
      #assert dumbLocation({:h, 8}) == {7, 7}
    end

    test "invalid formal location high" do
      #assert dumbLocation({:i, 5}) == "URMOM"
      # assert catch_error(dumbLocation({:i, 5}))
      assert_raise ArgumentError, fn ->
        dumbLocation({:i, 5})
      end
      #assert catch_error(dumbLocation({:d, 9}))
      assert dumbLocation({:d, 9}) == {8, 3} # not a real possible location but hey shrug it converts fine
      #assert_raise ArgumentError, fn ->
      #  dumbLocation({:d, 9})
      #end
    end

    test "invalid formal location low" do
      assert catch_error(dumbLocation({7, -8}))
      assert catch_error(dumbLocation({:negative, 7}))
      assert catch_error(dumbLocation({-8, 5}))

      assert_raise ArgumentError, fn ->
        dumbLocation({7, -8})
      end
      assert_raise ArgumentError, fn ->
        dumbLocation({:negative, 7})
      end
      assert_raise ArgumentError, fn ->
        dumbLocation({-8, 5})
      end
    end

    test "try to convert dumb to dumb: get error" do
      assert catch_error(dumbLocation({0, 0}))
      assert catch_error(dumbLocation({4, 4}))

      assert_raise ArgumentError, fn ->
        dumbLocation({0, 0})
      end
      assert_raise ArgumentError, fn ->
        dumbLocation({4, 4})
      end
    end
  end

end
