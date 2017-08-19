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


query = "query {
  repository(name: \"ironboard\", owner:\"flatiron-labs\") {
    name
    ref(qualifiedName: \"master\") {
      target {
        ... on Commit {
          id
          history(first: 100, author: {id: \"MDQ6VXNlcjEyNDA1MDQ=\"}, after: \"5262ce37ca79e49f28041cb7a0fdd766192933d8 0\") {
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

{:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.post("https://api.github.com/graphql", Poison.encode!(%{"query" => query}), [{"Authorization", "bearer #{System.get_env("GITHUB_ACCESS_TOKEN")}"}, {"Content-Type", "application/json"}])

history = body |> Poison.decode! |> Kernel.get_in(["data", "repository", "ref", "target", "history"])
hasNextPage = history["pageInfo"]["hasNextPage"]

commits = body |> Poison.decode! |> Kernel.get_in(["data", "repository", "ref", "target", "history", "edges"])

last_cursor = List.last(commits)["cursor"]

unless the edge message contains "merge"

# Make the request
# iterate over the edges and persist them unless the message contains "merge"
# save the last cursor
# if has next page is true, go again
# otherwise, stop
