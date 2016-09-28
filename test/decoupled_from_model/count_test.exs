defmodule Decoupled.CountTest do
  use ExUnit.Case, async: false
  doctest EctoShortcuts

  test "there are 9 users with user status 1" do
    assert 9 == MyApp.Users.count_where(user_status_id: 1)
  end

  test "there are 9 users with user status 1 using map" do
    assert 9 == MyApp.Users.count_where(%{user_status_id: 1})
  end

  test "there are 5 users with user status 2" do
    assert 5 == MyApp.Users.count_where(user_status_id: 2)
  end

  test "there are 5 users with user status 2 using map" do
    assert 5 == MyApp.Users.count_where(%{user_status_id: 2})
  end

  test "count matches the size of all" do
    assert MyApp.Users.count == Enum.count(MyApp.Users.all)
  end
end
