defmodule MyApp.UserWithoutChangeset do
  use Ecto.Schema
  use EctoShortcuts, repo: EctoShortcutsTest.Repo

  schema "users" do
    field :name, :string
    belongs_to :user_status, MyApp.UserStatus
    timestamps
  end
end
