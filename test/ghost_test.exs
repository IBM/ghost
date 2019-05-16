defmodule GhostTest do
  use ExUnit.Case
  doctest Ghost

  test "greets the world" do
    assert Ghost.hello() == :world
  end
end
