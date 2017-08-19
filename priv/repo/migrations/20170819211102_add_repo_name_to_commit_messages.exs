defmodule Commits.Repo.Migrations.AddRepoNameToCommitMessages do
  use Ecto.Migration

  def change do
    alter table(:commit_messages) do
      add :repo_name, :text
    end
  end
end
