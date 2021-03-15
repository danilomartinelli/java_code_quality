defmodule JavaCodeQualityTest do
  use ExUnit.Case
  doctest JavaCodeQuality

  test "greets the world" do
    assert JavaCodeQuality.hello() == :world
  end
end
