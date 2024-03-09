defmodule App.Store.Order do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id

    attribute :customer_name, :string, allow_nil?: false
  end

  aggregates do
    sum :subtotal, :order_items, :sub_total
  end

  relationships do
    has_many :order_items, App.Store.OrderItem
  end

  code_interface do
    define_for App.Store
    define :create, action: :create
    define :read_all, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
    define :get_by_id, args: [:id], action: :by_id
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    read :by_id do
      argument :id, :uuid, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end
  end

  graphql do
    type :order

    queries do
      list(:list_orders, :read)
    end

    mutations do
    end
  end

  postgres do
    table "orders"
    repo App.Repo
  end
end
