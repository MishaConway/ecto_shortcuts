defmodule Decoupled.UpdateTest do
  use ExUnit.Case, async: false
  doctest EctoShortcuts

  setup do
    on_exit fn ->
      TestData.reset
    end
  end

  test "update_all can update all statuses" do
    users = MyApp.Users.update_all set: [user_status_id: 5]
    Enum.each MyApp.Users.all, fn(user) ->
      assert 5 == user.user_status_id
    end
  end

  test "update by can set all users with status 5 to status 4" do
    num_status_4_users = MyApp.Users.count_where user_status_id: 4
    num_status_5_users = MyApp.Users.count_where user_status_id: 5

    assert num_status_5_users > 0

    MyApp.Users.update_by [user_status_id: 5], set: [user_status_id: 4]
    assert num_status_5_users + num_status_4_users == MyApp.Users.count_where(user_status_id: 4)
  end

  test "update by can set all users with status 5 to status 4 using map" do
    num_status_4_users = MyApp.Users.count_where user_status_id: 4
    num_status_5_users = MyApp.Users.count_where user_status_id: 5

    assert num_status_5_users > 0

    MyApp.Users.update_by %{user_status_id: 5}, %{set: [user_status_id: 4]}
    assert num_status_5_users + num_status_4_users == MyApp.Users.count_where(user_status_id: 4)
  end

  test "update_by_returning can update a user and return him" do
    # make sure user 3 doesn't have already have status 5
    assert 3 == MyApp.Users.get(3).user_status_id

    [user] = MyApp.Users.update_by_returning [id: 3], set: [user_status_id: 5]
    assert 3 == user.id
    assert 5 == user.user_status_id
    assert 5 == MyApp.Users.get(3).user_status_id
  end

  test "update_by_returning can update a user and return him using map" do
    # make sure user 3 doesn't have already have status 5
    assert 3 == MyApp.Users.get(3).user_status_id

    [user] = MyApp.Users.update_by_returning %{id: 3}, set: [user_status_id: 5]
    assert 3 == user.id
    assert 5 == user.user_status_id
    assert 5 == MyApp.Users.get(3).user_status_id
  end

  test "update_by_returning can update a user and return him preloading user_status" do
    # make sure user 3 doesn't have already have status 5
    assert 3 == MyApp.Users.get(3).user_status_id

    [user] = MyApp.Users.update_by_returning [id: 3], [set: [user_status_id: 5]], preload: [:user_status]
    assert 3 == user.id
    assert 5 == user.user_status.id
    assert 5 == MyApp.Users.get(3).user_status_id
  end
end
