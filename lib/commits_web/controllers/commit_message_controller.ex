defmodule CommitsWeb.CommitMessageController do
  use CommitsWeb, :controller

  alias Commits.Logs

  action_fallback CommitsWeb.FallbackController

  def index(conn, _params) do
    commit_messages = Logs.list_commit_messages()
    render(conn, "index.json", commit_messages: commit_messages)
  end

  def help(conn, _params) do
    commit_message = Logs.get_random_message()
    render(conn, "help.json", commit_message: commit_message)
  end

  def show(conn, %{"id" => id}) do
    commit_message = Logs.get_commit_message!(id)
    render(conn, "show.json", commit_message: commit_message)
  end

end
