defmodule Commits.Logs.CommitMessage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Commits.Logs.CommitMessage


  schema "commit_messages" do
    field :commited_at, :naive_datetime
    field :content, :string

    timestamps()
  end

  @doc false
  def changeset(%CommitMessage{} = commit_message, attrs) do
    commit_message
    |> cast(attrs, [:content, :commited_at])
    |> validate_required([:content, :commited_at])
  end
end
