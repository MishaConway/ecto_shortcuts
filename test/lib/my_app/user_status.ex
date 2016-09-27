defmodule MyApp.UserStatus do
  use Ecto.Schema
  use EctoShortcuts, repo: EctoShortcutsTest.Repo

  schema "users" do
    field :name, :string
    timestamps
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
