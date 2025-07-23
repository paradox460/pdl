defmodule PdlTest do
  use ExUnit.Case
  doctest Pdl

  describe "add/2" do
    test "adds values to new keys in the Process Dictionary" do
      assert Pdl.add(:foo, 1) == :ok
      assert Process.get(:foo) == [1]
    end

    test "adds values to existing keys in the Process Dictionary" do
      Process.put(:foo, [:bar, :baz])
      assert Pdl.add(:foo, 1) == :ok
      assert Process.get(:foo) == [1, :bar, :baz]
    end

    test "errors if the key has a non-list value in the Process Dictionary" do
      Process.put(:foo, "bar")
      assert Pdl.add(:foo, 1) == {:error, "Key `:foo` is not a list in process dictionary"}
      assert Process.get(:foo) == "bar"
    end
  end

  describe "add!/2" do
    test "raises on error" do
      Process.put(:foo, "bar")

      assert_raise ArgumentError, "Key `:foo` is not a list in process dictionary", fn ->
        Pdl.add!(:foo, 1)
      end
    end
  end

  describe "add_many/2" do
    test "adds multiple values to a new key in the Process Dictionary" do
      assert Pdl.add_many(:foo, [1, 2, 3]) == :ok
      assert Process.get(:foo) == [3, 2, 1]
    end

    test "adds multiple values to an existing key in the Process Dictionary" do
      Process.put(:foo, [4, 5])
      assert Pdl.add_many(:foo, [1, 2, 3]) == :ok
      assert Process.get(:foo) == [3, 2, 1, 4, 5]
    end

    test "errors if the key has a non-list value in the Process Dictionary" do
      Process.put(:foo, "bar")

      assert Pdl.add_many(:foo, [1, 2, 3]) ==
               {:error, "Key `:foo` is not a list in process dictionary"}
    end
  end

  describe "add_many!/2" do
    test "raises on error" do
      Process.put(:foo, "bar")

      assert_raise ArgumentError, "Key `:foo` is not a list in process dictionary", fn ->
        Pdl.add_many!(:foo, [1, 2, 3])
      end
    end
  end

  describe "run/2" do
    test "runs a function over the values in the Process Dictionary" do
      Process.put(:foo, [:bar])

      assert Pdl.run(:foo, fn val ->
               assert val == :bar
               :zaz
             end) == [:zaz]
    end

    test "returns all the responses from the function" do
      Process.put(:foo, [:baz, :bar])

      assert Pdl.run(:foo, fn val ->
               val
             end) == [:bar, :baz]
    end

    test "returns an empty list without running the function if the key doesn't exist or is empty" do
      assert Pdl.run(:foo, fn _val ->
               flunk("Ran the function!")
             end) == []
    end
  end

  describe "run_unique/2" do
    test "runs a function over the values in the Process Dictionary, ensuring uniqueness" do
      Process.put(:foo, [:bar, :baz, :bar])

      assert Pdl.run_unique(:foo, fn val ->
               assert val in [:bar, :baz]
               val
             end) == [:baz, :bar]
    end

    test "returns an empty list without running the function if the key doesn't exist or is empty" do
      assert Pdl.run_unique(:foo, fn _val ->
               flunk("Ran the function!")
             end) == []
    end
  end

  describe "run_all/2" do
    test "runs a function over the values in the Process Dictionary, receiving all responses as a variable, and returning result of function" do
      Process.put(:foo, [:bar, :baz])

      assert Pdl.run_all(:foo, fn vals ->
               assert vals == [:baz, :bar]
               :zaz
             end) == :zaz
    end
  end
end
