defmodule Decoupled.GetOrInsertTest do
  use ExUnit.Case, async: false
  doctest EctoShortcuts

  test "get_or_insert gets a user if he already exists" do
    original_count = MyApp.Users.count
    user = MyApp.Users.get_or_insert name: "Gabriel", user_status_id: 3
    assert 8 == user.id
    assert original_count == MyApp.Users.count
  end

  test "get_or_insert gets a user if he already exists using map" do
    original_count = MyApp.Users.count
    user = MyApp.Users.get_or_insert %{name: "Gabriel", user_status_id: 3}
    assert 8 == user.id
    assert original_count == MyApp.Users.count
  end

  test "get_or_insert inserts a user if he doesn't already exist" do
    original_count = MyApp.Users.count
    user = MyApp.Users.get_or_insert name: "Lucifer", user_status_id: 5
    assert original_count + 1 == MyApp.Users.count
  end

  test "get_or_insert inserts a user if he doesn't already exist using map" do
    original_count = MyApp.Users.count
    user = MyApp.Users.get_or_insert %{name: "Asura", user_status_id: 5}
    assert original_count + 1 == MyApp.Users.count
  end
end
