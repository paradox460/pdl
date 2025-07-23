defmodule PdlTest do
  use ExUnit.Case
  doctest Pdl

  test "greets the world" do
    assert Pdl.hello() == :world
  end
end
