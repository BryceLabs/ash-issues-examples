defmodule App.Store do
  use Ash.Domain, extensions: [AshGraphql.Domain]

  resources do
    resource App.Store.Organization
    resource App.Store.Order
    resource App.Store.OrderItem
  end

  graphql do
    authorize? false
  end
end
