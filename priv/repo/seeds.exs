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

  def query(repoName, owner, cursor) do
    "query {
      repository(name: \"#{repoName}\", owner:\"#{owner}\") {
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

  def get_commits(repoName, owner, cursor, hasNextPage) when hasNextPage == true do
    token = Application.get_env(:commits, :github_access_token)

    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.post("https://api.github.com/graphql", Poison.encode!(%{"query" => query(repoName, owner, cursor)}), [{"Authorization", "bearer #{token}"}, {"Content-Type", "application/json"}])

    history = body
      |> Poison.decode!
      |> Kernel.get_in(["data", "repository", "ref", "target", "history"])

    nextPage = history["pageInfo"]["hasNextPage"]

    commits = body
      |> Poison.decode!
      |> Kernel.get_in(["data", "repository", "ref", "target", "history", "edges"])

    Enum.map(commits, fn c -> save(c, repoName) end)

    last_cursor = List.last(commits)["cursor"]
    get_commits(repoName, owner, last_cursor, nextPage)
  end

  def get_commits(repoName, owner, cursor, hasNextPage) when hasNextPage == false do
    IO.puts cursor
  end

  def save(commit, repoName) do
    message = commit["node"]["message"]
    date    = commit["node"]["author"]["date"]

    if !String.contains?(message, "Merge") do
      IO.puts message
      {:ok, formatted_date} = NaiveDateTime.from_iso8601(date)
      Commits.Repo.insert!(%Commits.Logs.CommitMessage{content: message, committed_at: formatted_date, repo_name: repoName})
    end
  end
end

Seed.get_commits("ironboard", "flatiron-labs", "f1c4e5474064ce438659ac2c8532438baee6eba2 0", true)
Seed.get_commits("operations", "flatiron-labs", "bdd530b5972c5c16cd294d1194cf57c46bf7b666 0", true)
Seed.get_commits("ide_viewer", "flatiron-labs", "e0d33781fa2115488a8c4190572c76e12e357914 0", true)
Seed.get_commits("ide_umbrella", "flatiron-labs", "d7b5feaf95b02ffa6389098c62d1e3fe8ce0621a 0", true)
Seed.get_commits("students-chef-repo", "flatiron-labs", "fbb0548b256a7807d3e41b5e58421f0db29ce7fa 0", true)
Seed.get_commits("archive_server", "flatiron-labs", "d4e7276231215d76d5f6127994fa4b1400d2cbe0 0", true)
Seed.get_commits("atom-ile", "flatiron-labs", "c9db65918976f9cc5c6731e50c1445031bfbabf8 0", true)
Seed.get_commits("learn-web", "learn-co", "1d6928b4479a82df41acaa3c3a80c71ba5306eda 0", true)
Seed.get_commits("learn-submit", "learn-co", "3488a11ecc573d427eb8afe00a44c3766da8091a 0", true)
Seed.get_commits("learn-co", "learn-co", "fa7516938d6a7cbd57876065553371afc71bc06b 0", true)
Seed.get_commits("learn-open", "learn-co", "88d9c89d2cf958ac987e2d08f28ace6a4a77b589 0", true)
Seed.get_commits("learn-test", "learn-co", "987ce16cf59e3bf8a99008d01389eae88a4207ef 0", true)
