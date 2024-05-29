defmodule App.GraphqlSchema do
  use Absinthe.Schema

  use AshGraphql, domains: [App.Accounts]

  query do
  end

  mutation do
  end
end
