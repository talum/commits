defmodule CommitsWeb.Router do
  use CommitsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CommitsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  #Other scopes may use custom stacks.
  scope "/api", CommitsWeb do
    pipe_through :api

    resources "/commit_messages", CommitMessageController, except: [:new, :edit, :update, :delete]
    post "/help", CommitMessageController, :help
  end
end
