# EctoShortcuts 🚅

> Lightweight Elixir extension to simplify common use cases in Ecto.

## Installation

1. Get [Hex](https://hex.pm/packages/ecto_shortcuts)

2. Add `ecto_shortcuts` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:ecto_shortcuts, "~> 0.1.6"}]
  end
  ```

## Configuration   

In your Ecto Models:

```elixir
defmodule MyApp.User do
  ...
  use EctoShortcuts, repo: MyApp.Repo
  ...
end  
```
or, use the following approach that more closely mirrors the Phoenix model standards: 

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


**insert**
```elixir
	# create a new user named Bob
	MyApp.User.insert name: "Bob"
  MyApp.User.insert %{name: "Bob"}

  # create a new user named Alice without validation
	MyApp.User.insert name: "Alice", validate: false
  MyApp.User.insert %{name: "Alice"}, %{validate: false}
```

**insert!**
```elixir
	MyApp.User.insert! name: "Bob"
  MyApp.User.insert! %{name: "Bob"}

  MyApp.User.insert! name: "Alice", validate: false
  MyApp.User.insert! %{name: "Alice"}, %{validate: false}
```

**note:** If your model defines a changeset, `insert`, `insert!` & any validations  will by default use that changeset. To disable validation, use the validate: false option shown below. If your model lacks a changeset, then your model will be inserted without any validation.

--

**update_all**
```elixir
	# set status_id to 3 on all users
	MyApp.User.update_all set: [status_id: 3]
  MyApp.User.update_all %{set: [status_id: 3]}
```

**update_by**
```elixir
	# set status_id to 4 where mode is 3
	MyApp.User.update_by [mode: 3], set: [status_id: 4]
  MyApp.User.update_by %{mode: 3}, %{set: [status_id: 4]}
```

**update\_by\_returning**
```elixir
	# set status_id to 4 where mode is 3
	updated_users = MyApp.User.update_by_returning [mode: 3], set: [status_id: 4]

  # set status_id to 3 for user 1 and return updated user with posts association preloaded
  [updated_user] = MyApp.User.update_by_returning [id: 1], [set: [status_id: 3]], preload: [:posts]

  # same as above but using maps
  [updated_user] = MyApp.User.update_by_returning %{id: 1}, %{set: [status_id: 3]}, preload: [:posts]
```

**delete_all**
```elixir
	# delete all users
	MyApp.User.delete_all
```

**delete_by**
```elixir
	# delete all users where mode is 3
	MyApp.User.delete_by mode: 3
  MyApp.User.delete_by %{mode: 3}
```

**get**
```elixir
	# get user with id 3
	MyApp.User.get 3

  # get user with id 3 and preload posts association
  MyApp.User.get 3, preload: [:posts]

  # get user with id 3 and preload posts associations in addition to posts.post_type association
  MyApp.User.get 3, preload: [{:posts, :post_type}]
```

**get!**
```elixir
	MyApp.User.get! 3
  MyApp.User.get! 3, preload: [:posts]
  MyApp.User.get! 3, preload: [{:posts, :post_type}]
```

**get_by**
```elixir
	# fetch a single user where name is Sally and age is 30
	MyApp.User.get_by name: "Sally", age: 30

  # fetch a single user where name is Sally and preload the posts association
  MyApp.User.get_by [name: "Sally"],  preload: [:posts]

  # same as above but using maps
  MyApp.User.get_by %{name: "Sally"},  preload: [:posts]
```

**get_by!**
```elixir
	MyApp.User.get_by! name: "Sally", age: 30
  MyApp.User.get_by! [name: "Sally", age: 30],  preload: [:posts]
```

**where**
```elixir
	# get all users where status is 3
	MyApp.User.where status: 3

  # get all users where status is 3 and limit to 10 ordering by created_at
  MyApp.User.where [status: 3], limit: 10, order_by: [desc: :created_at]

  # same as above but using maps
  MyApp.User.where %{status: 3}, %{limit: 10, order_by: [desc: :created_at]}

  # same as above but preload the posts association
  MyApp.User.where [status: 3],  limit: 10, order_by: [desc: :inserted_at], preload: [:posts]
```

**get\_or\_insert**
```elixir
	# get user with name John Smith or insert user does not exist
	MyApp.User.get_or_insert first_name: "John", last_name: "Smith"

  MyApp.User.get_or_insert %{first_name: "John", last_name: "Smith"}
```

**get\_or\_insert!**
```elixir
	MyApp.User.get_or_insert! first_name: "John", last_name: "Smith"
```

**first**
```elixir
  # get first user
  MyApp.User.first

  # get first user preloading the posts association
  MyApp.User.first preload: [:posts]
```

**all**
```elixir
	# get all users
	MyApp.User.all

  # get all users preloading the posts association
  MyApp.User.all preload: [:posts]
```

**count**
```elixir
	# get count of all users
	MyApp.User.count
```

**count_where**
```elixir
	# get count of all users where status is 4
	MyApp.User.count_where status_id: 4

  MyApp.User.count_where %{status_id: 4}
```

## Wilcard Preloads

You can preload all associations via a wildcard, do

```elixir
  MyApp.User.get 3, preload: "*"
```

or

```elixir
  MyApp.User.get 3, preload: :*
```

## Default Preloads

You can set a default set of preloads.

```elixir
defmodule MyApp.Users do
  ...
  use EctoShortcuts, repo: MyApp.Repo,
                     model: MyApp.User,
                     default_preload: [:friends, :user_status, :posts]
  ...
end

or using wildcards

defmodule MyApp.Users do
  ...
  use EctoShortcuts, repo: MyApp.Repo,
                     model: MyApp.User,
                     default_preload: "*"
  ...
end
```

Now in any calls to shortcuts that take preloads, your queries will preload
the associations you specified without you needing to explicitly set preload options.

If you want to override defaults, you can pass in specific preloads you want.


## Running Tests

To run tests:
 
1. you will need `mysql` running, then
2. create a database you want tests to run on &
3. configure /config.exs.

By default, this creates database called `ecto\_shortcuts\_test` with the username `root` and password `root`.  default mysql port 3306.

Start testing!

```elixir
  mix test
```

### Coming Soon:
 * support for greater & less than comparisons
 * support for basic joins
 
NOTE: Ecto's DSL is rich & flexible. It should be deferred to for anything complex. 🙌
