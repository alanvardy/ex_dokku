defmodule ExDokkuTest do
  use ExUnit.Case
  doctest ExDokku

  test "greets the world" do
    assert ExDokku.hello() == :world
  end
end
