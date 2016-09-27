defmodule GetTest do
  use ExUnit.Case, async: false
  doctest EctoShortcuts

  test "get user 4 has name Turing" do
    user = MyApp.User.get 4
    assert "Turing" == user.name
  end

  test "get user 4 has name Turing and preloads user_status" do
    user = MyApp.User.get 4, preload: [:user_status]
    assert "Turing" == user.name
    assert MyApp.UserStatus == user.user_status.__struct__
  end

  test "get! user 9 has name Ernest" do
    user = MyApp.User.get 9
    assert "Ernest" == user.name
  end

  test "get! user 9 has name Ernest and preloads user status" do
    user = MyApp.User.get 9, preload: [:user_status]
    assert "Ernest" == user.name
    assert MyApp.UserStatus == user.user_status.__struct__
  end

  test "get_by Trump has name Trump" do
    user = MyApp.User.get_by name: "Trump"
    assert "Trump" == user.name
  end

  test "get_by Trump has name Trump and preloads user status" do
    user = MyApp.User.get_by [name: "Trump"], preload: [:user_status]
    assert "Trump" == user.name
    assert MyApp.UserStatus == user.user_status.__struct__
  end

  test "get_by! Hillary has name Hillary" do
    user = MyApp.User.get_by! name: "Hillary"
    assert "Hillary" == user.name
  end

  test "get_by! Hillary has name Hillary and preloads user status" do
    user = MyApp.User.get_by! [name: "Hillary"], preload: [:user_status]
    assert "Hillary" == user.name
    assert MyApp.UserStatus == user.user_status.__struct__
  end

  test "first user has name Bob" do
    user = MyApp.User.first
    assert "Bob" == user.name
  end

  test "first user has name Bob and preloads user status" do
    user = MyApp.User.first preload: [:user_status]
    assert "Bob" == user.name
    assert MyApp.UserStatus == user.user_status.__struct__
  end

  test "all users returns all users preloading user status" do
    users = MyApp.User.all preload: [:user_status]
    assert Enum.count(users) >= 18
    Enum.each users, fn(user) ->
      assert MyApp.UserStatus == user.user_status.__struct__
    end

  end

end
