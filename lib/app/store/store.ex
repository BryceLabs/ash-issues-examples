defmodule App.Store do
  use Ash.Api

  resources do
    resource App.Store.Order
    resource App.Store.OrderItem
  end
end
