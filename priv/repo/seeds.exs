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


HTTPoison.post("https://api.github.com/graphql", "{\"query\": \"query { viewer { login }}\"}", [{"Authorization", "bearer #{System.get_env("GITHUB_ACCESS_TOKEN")}"}])

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

HTTPoison.post("https://api.github.com/graphql", Poison.encode!(%{"query" => query}), [{"Authorization", "bearer #{System.get_env("GITHUB_ACCESS_TOKEN")}"}, {"Content-Type", "application/json"}])
