defmodule MyApp.User do
  use Ecto.Schema
  use EctoShortcuts, repo: EctoShortcutsTest.Repo

  schema "users" do
    field :name, :string
    belongs_to :user_status, MyApp.UserStatus
    timestamps
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :user_status_id])
    |> validate_required([:name, :user_status_id])
  end
end
