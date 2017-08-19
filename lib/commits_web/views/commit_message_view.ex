defmodule CommitsWeb.CommitMessageView do
  use CommitsWeb, :view
  alias CommitsWeb.CommitMessageView

  def render("index.json", %{commit_messages: commit_messages}) do
    %{data: render_many(commit_messages, CommitMessageView, "commit_message.json")}
  end

  def render("show.json", %{commit_message: commit_message}) do
    %{data: render_one(commit_message, CommitMessageView, "commit_message.json")}
  end

  def render("commit_message.json", %{commit_message: commit_message}) do
    %{id: commit_message.id,
      content: commit_message.content,
      committed_at: commit_message.committed_at}
  end
end
