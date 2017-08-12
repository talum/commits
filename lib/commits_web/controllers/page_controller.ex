defmodule CommitsWeb.PageController do
  use CommitsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
