# EctoShortcuts

Lightweight extension to simplify common use cases in Ecto.

What this is not is a comprehensive replacement. Ecto's DSL is rich and flexible and should be deferred to for anything complex.

## Installation

This code is available in Hex at (https://hex.pm/packages/ecto_shortcuts) and can be installed as:

  Add `ecto_shortcuts` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:ecto_shortcuts, "~> 0.1.0"}]
  end
  ```

## Configuration   

Use it in your Ecto Models

```elixir
defmodule MyApp.User do
  ...
  use EctoShortcuts, repo: MyApp.Repo
  ...
end  
```

## Usage

insert
```elixir
	# create a new user named Bob
	MyApp.User.insert name: "Bob"
```

insert!
```elixir
	MyApp.User.insert! name: "Bob"
```

update_all
```elixir
	# set status_id to 3 on all users
	MyApp.User.update_all set: [status_id: 3]
```

update_by
```elixir
	# set status_id to 4 where mode is 3
	MyApp.User.update_by [mode: 3], set: [status_id: 4]
```

update_by_returning
```elixir
	# set status_id to 4 where mode is 3
	updated_users = MyApp.User.update_by_returning [mode: 3], set: [status_id: 4]
```

delete_all
```elixir
	# delete all users
	MyApp.User.delete_all
```

delete_by
```elixir
	# delete all users where mode is 3
	MyApp.User.delete_by mode: 3
```

get
```elixir
	# get user with id 3
	MyApp.User.get 3
```

get!
```elixir
	MyApp.User.get! 3
```

get_by
```elixir
	# fetch a single user where name is Sally and age is 30
	MyApp.User.get_by name: "Sally", age: 30
```

get_by!
```elixir
	MyApp.User.get_by! name: "Sally", age: 30
```

where
```elixir
	# get all users where status is 3
	MyApp.User.where status: 3

    # get all users where status is 3 and
    #limit to 10 ordering by created_at
    MyApp.User.where [status: 3], limit: 10, order_by: [desc: :created_at]
```

get_or_insert
```elixir
	# get user with name John Smith or insert user does not exist
	MyApp.User.get_or_insert first_name: "John", last_name: "Smith"
```

get_or_insert!
```elixir
	MyApp.User.get_or_insert! first_name: "John", last_name: "Smith"
```

all
```elixir
	# get all users
	MyApp.User.all
```

count
```elixir
	# get count of all users
	MyApp.User.count
```

count_where
```elixir
	# get count of all users where status is 4
	MyApp.User.count_where status_id: 4
```




### Coming Soon:

 * support for greater and less than comparisons
 * support for basic joins
 * more documentation
 * tests
