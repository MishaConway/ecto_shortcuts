defmodule EctoShortcuts do
  @moduledoc """
  Shortcuts for Ecto gets, insertions, deletes, updates, where clauses, counts, etc.
  This module is strictly meant to simplify common Ecto usecases and you should
  defer to the Ecto way for more complicated logic that these shortcuts can't handle.

  Examples are in the [README](README.html).
  """

  require Ecto.Query

  defmacro __using__(opts) do
    unless repo = Keyword.get(opts, :repo) do
      raise ArgumentError,
       """
       expected :repo to be given as an option. Example:
       use EctoShortcuts, repo: MyApp.Repo
       """
    end

    quote do
      def repo do
        unquote repo
      end

      ######### INSERTS ##########

      defp new_changeset(attributes) do
        __MODULE__.changeset struct(__MODULE__), attributes
      end

      @doc """
      Inserts a new record. It returns {:ok, struct} if the struct has been
      successfully inserted or {:error, changeset} if there was a validation
      or a known constraint error.

      ## Examples

          iex> MyApp.User.insert name: "bob"

      """
      def insert(attributes) do
        repo.insert new_changeset(Enum.into(attributes, %{}))
      end

      @doc """
      Inserts a new record. Same as insert/1 but returns the struct or raises
      if the changeset is invalid.

      ## Examples

          iex> MyApp.User.insert! name: "bob"

      """
      def insert!(attributes) do
        repo.insert! new_changeset(Enum.into(attributes, %{}))
      end

      ######### UPDATES ##########

      @doc """
      Updates all records

      ## Examples

          iex> MyApp.User.update_all set: [status_id: 3]

      """
      def update_all(updates, opts \\ []) do
        repo.update_all(__MODULE__, updates, opts)
      end

      defp apply_filter(key, value, query) do
        from f in query,
        where: field(f, ^key) == ^value
      end

      defp reduce_filters(filters) do
        ecto_query = Ecto.Query.from x in __MODULE__
        Enum.reduce(filters, ecto_query, fn(filter, ecto_query) ->
          ecto_query = apply_filter(elem(filter, 0), elem(filter, 1), ecto_query)
        end)
      end

      @doc """
      Updates all records matching filters

      ## Examples

          iex> MyApp.User.update_by [mode: 3], set: [status_id: 4]

      """
      def update_by(filters, updates, opts \\ []) do
        reduce_filters(filters) |> repo.update_all(updates, opts)
      end


      ######## DELETES ##########


      @doc """
      Deletes all records

      ## Examples

          iex> MyApp.User.delete_all

      """
      def delete_all do
        repo.delete_all __MODULE__
      end

      @doc """
      Deletes all records matching filters

      ## Examples

          iex> MyApp.User.delete_by mode: 3

      """
      def delete_by(filters, opts \\ []) do
        reduce_filters(filters) |> repo.delete_all(opts)
      end


      ######### GETS ############

      @doc """
      Fetches a single struct from the data store where the primary key matches
      the given id. Returns nil if no result was found. An ArgumentError will be
      raised if more than one primary key exist.

      ## Examples

          iex> MyApp.User.get 3

      """
      def get(id, opts \\ []) do
        repo.get __MODULE__, id, opts
      end

      @doc """
      Similar to get/2 but raises Ecto.NoResultsError if no record was found.

      ## Examples

          iex> MyApp.User.get! 3

      """
      def get!(id, opts \\ []) do
        repo.get! __MODULE__, id, opts
      end

      @doc """
      Fetches a single record that matches filters. Returns nil if no result was found.

      ## Examples

          iex> MyApp.User.get_by name: "Sally"

      """
      def get_by(filters, opts \\ []) do
        repo.get_by __MODULE__, filters, opts
      end

      @doc """
      Similar to get_by/2 but raises Ecto.NoResultsError if no record was found.

      ## Examples

          iex> MyApp.User.get_by! name: "Sally"

      """
      def get_by!(clauses, opts \\ []) do
        repo.get_by! __MODULE__, clauses, opts
      end

      @doc """
      Retrieves first record from datastore.

      ## Examples

          iex> MyApp.User.first

      """
      def first do
        __MODULE__ |> Ecto.Query.first |> repo.one
      end


      @doc """
      Retrieves records matching attributes with optional order and limit

      ## Examples

          iex> MyApp.User.where status: 3

          iex> MyApp.User.where [status: 3], limit: 10, order_by: [desc: :created_at]

      """
      def where(attributes, options \\ []) do
        ecto_query =  if options[:limit] && options[:order_by] do
          limit_order_by_where options[:limit], options[:order_by]
        else
          if options[:limit] do
            limit_where options[:limit]
          else
            if options[:order_by] do
              order_by_where options[:order_by]
            else
              nil
            end
          end
        end

        ecto_query = ecto_query || __MODULE__
        ecto_query
        |> Ecto.Query.where(^attributes)
        |> repo.all
      end

      # silly method needed due to macro hell
      defp limit_where(limit) do
        Ecto.Query.from(__MODULE__, [limit: ^limit])
      end

      # silly method needed due to macro hell
      defp order_by_where(order_by) do
        Ecto.Query.from(__MODULE__, [order_by: ^order_by])
      end

      # silly method needed due to macro hell
      defp limit_order_by_where(limit, order_by) do
        Ecto.Query.from(__MODULE__, [limit: ^limit, order_by: ^order_by])
      end

      @doc """
      Retrieves first record matching attributes

      ## Examples

          iex> MyApp.User.first_where status: 3

      """
      def first_where(attributes) do
        __MODULE__
        |> Ecto.Query.where(^attributes)
        |> Ecto.Query.first
        |> repo.one
      end

      @doc """
      Finds record matching attributes or inserts it if it does not exist.

      ## Examples

          iex> MyApp.User.get_or_insert first_name: "John", last_name: "Smith"

      """
      def get_or_insert(attributes) do
        record = first_where(attributes)
        if record do
          record
        else
          insert attributes
        end
      end


      @doc """
      Finds record matching attributes or inserts it if it does not exist.

      ## Examples

          iex> MyApp.User.get_or_insert! first_name: "John", last_name: "Smith"

      """
      def get_or_insert!(attributes) do
        record = first_where(attributes)
        if record do
          record
        else
          insert! attributes
        end
      end

      @doc """
      Retrieves all records from dataset.

      ## Examples

          iex> MyApp.User.all

      """
      def all do
        __MODULE__ |> repo.all
      end

      @doc """
      Retrieves count of all records in dataset.

      ## Examples

          iex> MyApp.User.count

      """
      def count do
        repo.one(Ecto.Query.from p in __MODULE__, select: count("id"))
      end


      @doc """
      Retrieves count of all records in dataset matching filters

      ## Examples

          iex> MyApp.User.count_where status_id: 4

      """
      def count_where(filters) do
        Ecto.Query.from(p in __MODULE__, select: count("id"))
        |> Ecto.Query.where(^filters)
        |> repo.one
      end
    end
  end
end