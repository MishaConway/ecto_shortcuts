defmodule InsertTest do
  use ExUnit.Case, async: false
  doctest EctoShortcuts

  test "users can be inserted" do
    {:ok, user} = MyApp.User.insert name: "coolio", user_status_id: 4
    assert "coolio" == user.name
    assert 4 == user.user_status_id
  end

  test "users can be inserted!" do
    user = MyApp.User.insert! name: "amelia", user_status_id: 5
    assert "amelia" == user.name
    assert 5 == user.user_status_id
  end

  test "users without changesets can be inserted" do
    {:ok, user} = MyApp.UserWithoutChangeset.insert name: "bart", user_status_id: 4
    assert "bart" == user.name
    assert 4 == user.user_status_id
  end

  test "users without changesets can be inserted!" do
    user = MyApp.UserWithoutChangeset.insert! name: "lorde", user_status_id: 4
    assert "lorde" == user.name
    assert 4 == user.user_status_id
  end
end
