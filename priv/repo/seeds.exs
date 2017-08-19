# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Commits.Repo.insert!(%Commits.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as t

require IEx

defmodule Seed do

  def query(cursor) do
    "query {
      repository(name: \"ironboard\", owner:\"flatiron-labs\") {
        name
        ref(qualifiedName: \"master\") {
          target {
            ... on Commit {
              id
              history(first: 100, author: {id: \"MDQ6VXNlcjEyNDA1MDQ=\"}, after: \"#{cursor}\") {
                pageInfo {
                  hasNextPage
                }
                edges {
                  node {
                    oid
                    message
                    author() {
                      name
                      date
                    }
                  }
                  cursor
                }
              }
            }
          }
        }
      }
    }"
  end

  def get_commits(cursor, hasNextPage) when hasNextPage == true do
    token = Application.get_env(:commits, :github_access_token)

    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.post("https://api.github.com/graphql", Poison.encode!(%{"query" => query(cursor)}), [{"Authorization", "bearer #{token}"}, {"Content-Type", "application/json"}])

    history = body
      |> Poison.decode!
      |> Kernel.get_in(["data", "repository", "ref", "target", "history"])

    nextPage = history["pageInfo"]["hasNextPage"]

    commits = body
      |> Poison.decode!
      |> Kernel.get_in(["data", "repository", "ref", "target", "history", "edges"])

    Enum.map(commits, fn c -> save(c) end)

    last_cursor = List.last(commits)["cursor"]
    get_commits(last_cursor, nextPage)
  end

  def get_commits(cursor, hasNextPage) when hasNextPage == false do
    IO.puts cursor
  end

  def save(commit) do
    message = commit["node"]["message"]
    date    = commit["node"]["author"]["date"]

    if !String.contains?(message, "Merge") do
      IO.puts message
      {:ok, formatted_date} = NaiveDateTime.from_iso8601(date)
      Commits.Repo.insert!(%Commits.Logs.CommitMessage{content: message, committed_at: formatted_date})
    end
  end
end

Seed.get_commits("5262ce37ca79e49f28041cb7a0fdd766192933d8 0", true)
