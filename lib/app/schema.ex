defmodule App.Schema do
  use Absinthe.Schema

  @apis [App.Store]

  use AshGraphql, apis: @apis

  query do
  end

  mutation do
  end
end
