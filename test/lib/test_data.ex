defmodule TestData do
  use Application

  def reset do
    #clean test database
    Ecto.Migrator.down(EctoShortcutsTest.Repo, 20160827201529, EctoShortcutsTest.InitialMigration)

    #recreate test database
    Ecto.Migrator.up(EctoShortcutsTest.Repo, 20160827201529, EctoShortcutsTest.InitialMigration)

    #seed test database with raw sql statements (independent of ecto_shortcuts)
    ["new", "registered", "cancelled", "cool", "lame"]
    |> Enum.each(fn (name) ->
      Ecto.Adapters.SQL.query(EctoShortcutsTest.Repo, "INSERT INTO user_statuses (name, inserted_at, updated_at) VALUES ('#{name}', now(), now())", [])
    end)

    [
      %{name: "Bob", user_status_id: 1},
      %{name: "Dylan", user_status_id: 2},
      %{name: "Alan", user_status_id: 3},
      %{name: "Turing", user_status_id: 2},
      %{name: "Big", user_status_id: 2},
      %{name: "Boss", user_status_id: 3},
      %{name: "Peter", user_status_id: 3},
      %{name: "Gabriel", user_status_id: 3},
      %{name: "Ernest", user_status_id: 1},
      %{name: "Hemingway", user_status_id: 1},
      %{name: "Hillary", user_status_id: 1},
      %{name: "Clinton", user_status_id: 1},
      %{name: "Donald", user_status_id: 2},
      %{name: "Trump", user_status_id: 2},
      %{name: "Marie", user_status_id: 1},
      %{name: "Curie", user_status_id: 1},
      %{name: "Snoop", user_status_id: 1},
      %{name: "Dogg", user_status_id: 1},
      %{name: "Avery", user_status_id: 5},
      %{name: "Zeus", user_status_id: 5},
    ] |> Enum.each(fn(attributes) ->
      Ecto.Adapters.SQL.query(EctoShortcutsTest.Repo, "INSERT INTO users (name, user_status_id, inserted_at, updated_at) VALUES ('#{attributes[:name]}', #{attributes[:user_status_id]},now(), now())", [])
    end)
  end
end
