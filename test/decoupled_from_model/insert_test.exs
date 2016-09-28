defmodule Decoupled.InsertTest do
  use ExUnit.Case, async: false
  doctest EctoShortcuts

  test "users can be inserted" do
    {:ok, user} = MyApp.Users.insert name: "coolio", user_status_id: 4
    assert "coolio" == user.name
    assert 4 == user.user_status_id
  end

  test "users can be inserted with a map" do
    {:ok, user} = MyApp.Users.insert %{name: "kenan", user_status_id: 4}
    assert "kenan" == user.name
    assert 4 == user.user_status_id
  end

  test "users can be inserted!" do
    user = MyApp.Users.insert! name: "amelia", user_status_id: 5
    assert "amelia" == user.name
    assert 5 == user.user_status_id
  end

  test "users can be inserted! with a map" do
    user = MyApp.Users.insert! %{name: "earhart", user_status_id: 5}
    assert "earhart" == user.name
    assert 5 == user.user_status_id
  end

  test "users can be inserted without validation" do
    {:ok, user} = MyApp.Users.insert [name: "baba"], validate: false
    assert "baba" == user.name
  end

  test "users can be inserted! without validation" do
    user = MyApp.Users.insert! %{name: "booey"}, %{validate: false}
    assert "booey" == user.name
  end
end
