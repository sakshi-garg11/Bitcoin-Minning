mix ddefmodule DosTest do
  use ExUnit.Case
  doctest Dos

  test "greets the world" do
    assert Dos.hello() == :world
  end
end
