defmodule App.GraphqlSchema do
  use Absinthe.Schema

  use AshGraphql, domains: [App.Accounts, App.Businesses]

  query do
  end

  mutation do
  end
end
