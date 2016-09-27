defmodule Decoupled.DeleteTest do
  use ExUnit.Case, async: false
  doctest EctoShortcuts

  setup do
    on_exit fn ->
      TestData.reset
    end
  end

  test "delete_all deletes all users" do
    assert 0 < MyApp.Users.count
    MyApp.Users.delete_all
    assert 0 == MyApp.Users.count
  end

  test "delete_by deletes all users with status 3" do
    assert 0 < MyApp.Users.count_where user_status_id: 3
    MyApp.Users.delete_by user_status_id: 3
    assert 0 == MyApp.Users.count_where user_status_id: 3
  end
end
