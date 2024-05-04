defmodule App.Store do
  use Ash.Domain, extensions: [AshGraphql.Domain]

  resources do
    resource App.Store.Order
    resource App.Store.OrderItem
    resource App.Store.OrderItemModifier
  end

  graphql do
    authorize? false
  end
end
