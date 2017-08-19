defmodule CommitsWeb.CommitMessageControllerTest do
  use CommitsWeb.ConnCase

  alias Commits.Logs
  alias Commits.Logs.CommitMessage

  @create_attrs %{committed_at: ~N[2010-04-17 14:00:00.000000], content: "some content"}
  @update_attrs %{committed_at: ~N[2011-05-18 15:01:01.000000], content: "some updated content"}
  @invalid_attrs %{committed_at: nil, content: nil}

  def fixture(:commit_message) do
    {:ok, commit_message} = Logs.create_commit_message(@create_attrs)
    commit_message
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all commit_messages", %{conn: conn} do
      conn = get conn, commit_message_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create commit_message" do
    test "renders commit_message when data is valid", %{conn: conn} do
      conn = post conn, commit_message_path(conn, :create), commit_message: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, commit_message_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "committed_at" => ~N[2010-04-17 14:00:00.000000],
        "content" => "some content"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, commit_message_path(conn, :create), commit_message: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update commit_message" do
    setup [:create_commit_message]

    test "renders commit_message when data is valid", %{conn: conn, commit_message: %CommitMessage{id: id} = commit_message} do
      conn = put conn, commit_message_path(conn, :update, commit_message), commit_message: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, commit_message_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "committed_at" => ~N[2011-05-18 15:01:01.000000],
        "content" => "some updated content"}
    end

    test "renders errors when data is invalid", %{conn: conn, commit_message: commit_message} do
      conn = put conn, commit_message_path(conn, :update, commit_message), commit_message: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete commit_message" do
    setup [:create_commit_message]

    test "deletes chosen commit_message", %{conn: conn, commit_message: commit_message} do
      conn = delete conn, commit_message_path(conn, :delete, commit_message)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, commit_message_path(conn, :show, commit_message)
      end
    end
  end

  defp create_commit_message(_) do
    commit_message = fixture(:commit_message)
    {:ok, commit_message: commit_message}
  end
end
