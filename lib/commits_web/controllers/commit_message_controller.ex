defmodule CommitsWeb.CommitMessageController do
  use CommitsWeb, :controller

  alias Commits.Logs
  alias Commits.Logs.CommitMessage

  action_fallback CommitsWeb.FallbackController

  def index(conn, _params) do
    commit_messages = Logs.list_commit_messages()
    render(conn, "index.json", commit_messages: commit_messages)
  end

  def create(conn, %{"commit_message" => commit_message_params}) do
    with {:ok, %CommitMessage{} = commit_message} <- Logs.create_commit_message(commit_message_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", commit_message_path(conn, :show, commit_message))
      |> render("show.json", commit_message: commit_message)
    end
  end

  def help(conn, _params) do
    commit_message = Logs.get_random_message()
    render(conn, "help.json", commit_message: commit_message)
  end

  def show(conn, %{"id" => id}) do
    commit_message = Logs.get_commit_message!(id)
    render(conn, "show.json", commit_message: commit_message)
  end

  def update(conn, %{"id" => id, "commit_message" => commit_message_params}) do
    commit_message = Logs.get_commit_message!(id)

    with {:ok, %CommitMessage{} = commit_message} <- Logs.update_commit_message(commit_message, commit_message_params) do
      render(conn, "show.json", commit_message: commit_message)
    end
  end

  def delete(conn, %{"id" => id}) do
    commit_message = Logs.get_commit_message!(id)
    with {:ok, %CommitMessage{}} <- Logs.delete_commit_message(commit_message) do
      send_resp(conn, :no_content, "")
    end
  end
end
