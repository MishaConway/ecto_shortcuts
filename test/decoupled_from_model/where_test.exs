defmodule Decoupled.WhereTest do
  use ExUnit.Case, async: false
  doctest EctoShortcuts

  test "where query on users where status is 2 with limit of 5 returns 5 users with status of 2" do
    users = MyApp.Users.where [user_status_id: 2], limit: 5
    assert 5 == Enum.count(users)
    Enum.each users, fn(user) ->
      assert 2 == user.user_status_id
    end
  end

  test "same query as above but preloading user_status returns users with user_status association preloaded" do
    users = MyApp.Users.where [user_status_id: 2], limit: 5, preload: [:user_status]
    Enum.each users, fn(user) ->
      assert 2 == user.user_status.id
    end
  end

  test "where query on users ordered by name in descending order returns a list of users sorted by name in descending order" do
    users = MyApp.Users.where [], limit: 5, order_by: [desc: :name]
    assert ["Zeus", "Turing", "Trump", "Snoop", "Peter"] == Enum.map users, fn(user) ->
      user.name
    end
  end
end
