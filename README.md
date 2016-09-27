# EctoShortcuts

Lightweight extension to simplify common use cases in Ecto.

What this is not is a comprehensive replacement. Ecto's DSL is rich and flexible and should be deferred to for anything complex.

## Installation

This code is available in Hex at (https://hex.pm/packages/ecto_shortcuts) and can be installed as:

  Add `ecto_shortcuts` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:ecto_shortcuts, "~> 0.1.3"}]
  end
  ```

## Configuration   

Use it in your Ecto Models.

```elixir
defmodule MyApp.User do
  ...
  use EctoShortcuts, repo: MyApp.Repo
  ...
end  
```

The approach above is the original pattern adopted by this library, but moving forward it is recommended to
use the following approach that more closely mirrors the new Phoenix model standards in that you can decouple shortcuts
from your model by using in a separate module. The benefit of this approach is you don't couple repositories directly to schemas
and you can even create shortcuts for the same schema across multiple repos.

```elixir
defmodule MyApp.RepoAUsers do
  ...
  use EctoShortcuts, repo: MyApp.RepoA, model: MyApp.User
  ...
end

defmodule MyApp.RepoBUsers do
  ...
  use EctoShortcuts, repo: MyApp.RepoB, model: MyApp.User
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

  # set status_id to 3 for user 1 and return updated user with posts association preloaded
  [updated_user] = MyApp.User.update_by_returning [id: 1], [set: [status_id: 3]], preload: [:posts]
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

  # get user with id 3 and preload posts association
  MyApp.User.get 3, preload: [:posts]

  # get user with id 3 and preload posts associations in addition to posts.post_type association
  MyApp.User.get 3, preload: [{:posts, :post_type}]
```

get!
```elixir
	MyApp.User.get! 3
  MyApp.User.get! 3, preload: [:posts]
  MyApp.User.get! 3, preload: [{:posts, :post_type}]
```

get_by
```elixir
	# fetch a single user where name is Sally and age is 30
	MyApp.User.get_by name: "Sally", age: 30

  # fetch a single user where name is Sally and preload the posts association
  MyApp.User.get_by [name: "Sally"],  preload: [:posts]
```

get_by!
```elixir
	MyApp.User.get_by! name: "Sally", age: 30
  MyApp.User.get_by! [name: "Sally", age: 30],  preload: [:posts]
```

where
```elixir
	# get all users where status is 3
	MyApp.User.where status: 3

  # get all users where status is 3 and limit to 10 ordering by created_at
  MyApp.User.where [status: 3], limit: 10, order_by: [desc: :created_at]

  # same as above but preload the posts association
  MyApp.User.where [status: 3],  limit: 10, order_by: [desc: :inserted_at], preload: [:posts]
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

first
```elixir
  # get first user
  MyApp.User.first

  # get first user preloading the posts association
  MyApp.User.first preload: [:posts]
```

all
```elixir
	# get all users
	MyApp.User.all

  # get all users preloading the posts association
  MyApp.User.all preload: [:posts]
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

## Running Tests

To run tests, you will need to have mysql running. Create a database you want tests to run on and then
configure /config.exs.

By default, it assumes a database called ecto_shortcuts_test with username root and password root
running on localhost on the default mysql port 3306.

Once you have set this up, you can now start testing!

```elixir
  mix test
```


### Coming Soon:
 * ability to place this code in modules separate from your models to support new Phoenix guidelines
 * support for greater and less than comparisons
 * support for basic joins
