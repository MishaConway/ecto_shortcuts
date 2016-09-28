defmodule MyApp.UsersWithDefaultPreloads do
  use EctoShortcuts, repo: EctoShortcutsTest.Repo,
                     model: MyApp.User,
                     default_preload: "*"
end
