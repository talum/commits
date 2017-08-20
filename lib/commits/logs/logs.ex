defmodule Commits.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias Commits.Repo

  alias Commits.Logs.CommitMessage

  def get_random_message do
    count = Repo.all(CommitMessage)
            |> Enum.count
    random_id = :rand.uniform(count)

    Repo.get!(CommitMessage, random_id)
  end

  @doc """
  Returns the list of commit_messages.

  ## Examples

      iex> list_commit_messages()
      [%CommitMessage{}, ...]

  """
  def list_commit_messages do
    Repo.all(CommitMessage)
  end

  @doc """
  Gets a single commit_message.

  Raises `Ecto.NoResultsError` if the Commit message does not exist.

  ## Examples

      iex> get_commit_message!(123)
      %CommitMessage{}

      iex> get_commit_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_commit_message!(id), do: Repo.get!(CommitMessage, id)

  @doc """
  Creates a commit_message.

  ## Examples

      iex> create_commit_message(%{field: value})
      {:ok, %CommitMessage{}}

      iex> create_commit_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_commit_message(attrs \\ %{}) do
    %CommitMessage{}
    |> CommitMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a commit_message.

  ## Examples

      iex> update_commit_message(commit_message, %{field: new_value})
      {:ok, %CommitMessage{}}

      iex> update_commit_message(commit_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_commit_message(%CommitMessage{} = commit_message, attrs) do
    commit_message
    |> CommitMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CommitMessage.

  ## Examples

      iex> delete_commit_message(commit_message)
      {:ok, %CommitMessage{}}

      iex> delete_commit_message(commit_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_commit_message(%CommitMessage{} = commit_message) do
    Repo.delete(commit_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking commit_message changes.

  ## Examples

      iex> change_commit_message(commit_message)
      %Ecto.Changeset{source: %CommitMessage{}}

  """
  def change_commit_message(%CommitMessage{} = commit_message) do
    CommitMessage.changeset(commit_message, %{})
  end
end
