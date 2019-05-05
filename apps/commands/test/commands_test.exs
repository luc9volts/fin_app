defmodule CommandsTest do
  use ExUnit.Case
  doctest Commands

  test "greets the world" do
    assert Commands.hello() == :world
  end
end
