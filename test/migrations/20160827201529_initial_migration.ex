defmodule EctoShortcutsTest.InitialMigration do
  use Ecto.Migration

  def up do
    create table(:user_statuses) do
      add :name, :string, null: false
      timestamps
    end

    create table(:users) do
      add :name, :string, null: false
      add :user_status_id, :integer, null: false, default: 0
      timestamps
    end
  end

  def down do
    drop_if_exists table(:user_statuses)
    drop_if_exists table(:users)
  end
end
