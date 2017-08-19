defmodule Commits.LogsTest do
  use Commits.DataCase

  alias Commits.Logs

  describe "commit_messages" do
    alias Commits.Logs.CommitMessage

    @valid_attrs %{commited_at: ~N[2010-04-17 14:00:00.000000], content: "some content"}
    @update_attrs %{commited_at: ~N[2011-05-18 15:01:01.000000], content: "some updated content"}
    @invalid_attrs %{commited_at: nil, content: nil}

    def commit_message_fixture(attrs \\ %{}) do
      {:ok, commit_message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Logs.create_commit_message()

      commit_message
    end

    test "list_commit_messages/0 returns all commit_messages" do
      commit_message = commit_message_fixture()
      assert Logs.list_commit_messages() == [commit_message]
    end

    test "get_commit_message!/1 returns the commit_message with given id" do
      commit_message = commit_message_fixture()
      assert Logs.get_commit_message!(commit_message.id) == commit_message
    end

    test "create_commit_message/1 with valid data creates a commit_message" do
      assert {:ok, %CommitMessage{} = commit_message} = Logs.create_commit_message(@valid_attrs)
      assert commit_message.commited_at == ~N[2010-04-17 14:00:00.000000]
      assert commit_message.content == "some content"
    end

    test "create_commit_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logs.create_commit_message(@invalid_attrs)
    end

    test "update_commit_message/2 with valid data updates the commit_message" do
      commit_message = commit_message_fixture()
      assert {:ok, commit_message} = Logs.update_commit_message(commit_message, @update_attrs)
      assert %CommitMessage{} = commit_message
      assert commit_message.commited_at == ~N[2011-05-18 15:01:01.000000]
      assert commit_message.content == "some updated content"
    end

    test "update_commit_message/2 with invalid data returns error changeset" do
      commit_message = commit_message_fixture()
      assert {:error, %Ecto.Changeset{}} = Logs.update_commit_message(commit_message, @invalid_attrs)
      assert commit_message == Logs.get_commit_message!(commit_message.id)
    end

    test "delete_commit_message/1 deletes the commit_message" do
      commit_message = commit_message_fixture()
      assert {:ok, %CommitMessage{}} = Logs.delete_commit_message(commit_message)
      assert_raise Ecto.NoResultsError, fn -> Logs.get_commit_message!(commit_message.id) end
    end

    test "change_commit_message/1 returns a commit_message changeset" do
      commit_message = commit_message_fixture()
      assert %Ecto.Changeset{} = Logs.change_commit_message(commit_message)
    end
  end
end
