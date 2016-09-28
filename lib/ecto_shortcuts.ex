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

    model = Keyword.get opts, :model
    default_preload = Keyword.get opts, :default_preload

    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      def repo do
        unquote repo
      end

      def model do
        unquote(model) || __MODULE__
      end

      def default_preload do
        unquote(default_preload)
      end

      defp normalize_attributes( attributes ) do
        if is_map attributes do
          Map.to_list attributes
        else
          attributes
        end
      end


      ######### PRELOADING ##########

      defp pload( preloadable, opts ) do
        preloads = normalize_pload_list( opts[:preload] || opts[:preloads] || default_preload || [] )

        if Enum.count(preloads) > 0 do
          preloadable |> repo.preload(preloads)
        else
          preloadable
        end
      end

      defp normalize_pload_list( pload_list ) do
        case pload_list do
          :* -> model.__schema__(:associations)
          "*" -> model.__schema__(:associations)
          _ -> pload_list
        end
      end

      ######### INSERTS ##########

      defp new_changeset(attributes, opts ) do
        disable_validation = false == (opts || [])[:validate]

        if !disable_validation && model.module_info(:exports)[:changeset] do
          model.changeset struct(model), attributes
        else
          struct(model, attributes)
        end
      end

      @doc """
      Inserts a new record. It returns {:ok, struct} if the struct has been
      successfully inserted or {:error, changeset} if there was a validation
      or a known constraint error.

      ## Examples

          iex> MyApp.User.insert name: "bob"

      """
      def insert(attributes, opts \\ []) do
        repo.insert new_changeset(Enum.into(attributes, %{}), opts)
      end

      @doc """
      Inserts a new record. Same as insert/1 but returns the struct or raises
      if the changeset is invalid.

      ## Examples

          iex> MyApp.User.insert! name: "bob"

      """
      def insert!(attributes, opts \\ []) do
        repo.insert! new_changeset(Enum.into(attributes, %{}), opts)
      end

      ######### UPDATES ##########

      @doc """
      Updates all records

      ## Examples

          iex> MyApp.User.update_all set: [status_id: 3]

      """
      def update_all(updates, opts \\ []) do
        repo.update_all(model, updates, opts)
      end

      defp apply_filter(key, value, query) do
        from f in query,
        where: field(f, ^key) == ^value
      end

      defp reduce_filters(filters) do
        ecto_query = Ecto.Query.from x in model
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
        reduce_filters(filters) |> repo.update_all(normalize_attributes(updates), opts)
      end


      @doc """
      Updates all records matching filters and returns the updated records via a second query.
      Useful for when MyApp.User.update_by [id: 3], [set: [status_id: 4]], returning: true
      results in ** (ArgumentError) RETURNING is not supported in update_all by MySQL

      ## Examples

          iex> updated_users = MyApp.User.update_by_returning [mode: 3], set: [status_id: 4]
          iex> [updated_user] = MyApp.User.update_by_returning [id: 1], [set: [status_id: 3]], preload: [:posts]

      """
      def update_by_returning(filters, updates, opts \\ []) do
        {num_rows, result} = update_by filters, updates, opts
        if num_rows > 0 do
          where(normalize_attributes(filters)) |> pload(opts)
        else
          []
        end
      end



      ######## DELETES ##########


      @doc """
      Deletes all records

      ## Examples

          iex> MyApp.User.delete_all

      """
      def delete_all do
        repo.delete_all model
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
          iex> MyApp.User.get 3, preload: [:posts]
          iex> MyApp.User.get 3, preload: [{:posts, :post_type}]

      """
      def get(id, opts \\ []) do
        repo.get(model, id, opts) |> pload( opts )
      end

      @doc """
      Similar to get/2 but raises Ecto.NoResultsError if no record was found.

      ## Examples

          iex> MyApp.User.get! 3
          iex> MyApp.User.get! 3, preload: [:posts]
          iex> MyApp.User.get! 3, preload: [{:posts, :post_type}]

      """
      def get!(id, opts \\ []) do
        repo.get!(model, id, opts) |> pload( opts )
      end

      @doc """
      Fetches a single record that matches filters. Returns nil if no result was found.

      ## Examples

          iex> MyApp.User.get_by name: "Sally"
          iex> MyApp.User.get_by [name: "Sally"],  preload: [:posts]
          iex> MyApp.User.get_by [name: "Sally"], preload: [{:posts, :post_type}]

      """
      def get_by(filters, opts \\ []) do
        repo.get_by(model, filters, opts) |> pload( opts )
      end

      @doc """
      Similar to get_by/2 but raises Ecto.NoResultsError if no record was found.

      ## Examples

          iex> MyApp.User.get_by! name: "Sally"
          iex> MyApp.User.get_by! [name: "Sally"],  preload: [:posts]
          iex> MyApp.User.get_by! [name: "Sally"], preload: [{:posts, :post_type}]

      """
      def get_by!(clauses, opts \\ []) do
        repo.get_by!(model, clauses, opts) |> pload( opts )
      end

      @doc """
      Retrieves first record from datastore.

      ## Examples

          iex> MyApp.User.first
          iex> MyApp.User.first preload: [:posts]
          iex> MyApp.User.first preload: [{:posts, :post_type}]

      """
      def first( opts \\ [] ) do
        model |> Ecto.Query.first |> repo.one |> pload( opts )
      end


      @doc """
      Retrieves records matching attributes with optional order and limit

      ## Examples

          iex> MyApp.User.where status: 3
          iex> MyApp.User.where [status: 3], limit: 10, order_by: [desc: :inserted_at]
          iex> MyApp.User.where [status: 3],  limit: 10, order_by: [desc: :inserted_at], preload: [:posts]


      """
      def where(attributes, options \\ []) do
        options = normalize_attributes options
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

        ecto_query = ecto_query || model
        ecto_query
        |> Ecto.Query.where(^normalize_attributes(attributes))
        |> repo.all
        |> pload(options)
      end

      # silly method needed due to macro hell
      defp limit_where(limit) do
        Ecto.Query.from(model, [limit: ^limit])
      end

      # silly method needed due to macro hell
      defp order_by_where(order_by) do
        Ecto.Query.from(model, [order_by: ^order_by])
      end

      # silly method needed due to macro hell
      defp limit_order_by_where(limit, order_by) do
        Ecto.Query.from(model, [limit: ^limit, order_by: ^order_by])
      end

      @doc """
      Retrieves first record matching attributes

      ## Examples

          iex> MyApp.User.first_where status: 3

      """
      def first_where(attributes) do
        model
        |> Ecto.Query.where(^normalize_attributes(attributes))
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
          iex> MyApp.User.all preload: [:posts]

      """
      def all(opts \\ []) do
        model |> repo.all |> pload(opts)
      end

      @doc """
      Retrieves count of all records in dataset.

      ## Examples

          iex> MyApp.User.count

      """
      def count do
        repo.one(Ecto.Query.from p in model, select: count("id"))
      end


      @doc """
      Retrieves count of all records in dataset matching filters

      ## Examples

          iex> MyApp.User.count_where status_id: 4

      """
      def count_where(filters) do
        Ecto.Query.from(p in model, select: count("id"))
        |> Ecto.Query.where(^normalize_attributes(filters))
        |> repo.one
      end
    end
  end
end
