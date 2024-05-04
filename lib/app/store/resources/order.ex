defmodule App.Store.Order do
  use Ash.Resource,
    domain: App.Store,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id

    attribute :customer_name, :string do
      allow_nil? false
      public? true
    end
  end

  aggregates do
    sum :subtotal, :order_items, :subtotal, public?: true
  end

  relationships do
    has_many :order_items, App.Store.OrderItem, public?: true
  end

  code_interface do
    domain App.Store
    define :create, action: :create
    define :read_all, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
    define :get_by_id, args: [:id], action: :by_id
  end

  actions do
    default_accept :*
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
      get(:order, :read)
      list :list_orders, :read, paginate_with: nil
    end
  end

  postgres do
    table "orders"
    repo App.Repo
  end
end
