defmodule Commits.Repo.Migrations.CreateCommitMessages do
  use Ecto.Migration

  def change do
    create table(:commit_messages) do
      add :content, :text
      add :committed_at, :naive_datetime

      timestamps()
    end

  end
end
