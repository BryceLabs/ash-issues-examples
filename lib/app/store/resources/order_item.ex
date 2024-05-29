defmodule App.Store.OrderItem do
  use Ash.Resource,
    domain: App.Store,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id

    attribute :product_name, :string, allow_nil?: false, public?: true
    attribute :size_name, :string, allow_nil?: true, public?: true

    attribute :quantity, :decimal, allow_nil?: false, public?: true
    attribute :price, :decimal, allow_nil?: false, public?: true
  end

  calculations do
    calculate :subtotal, :string, expr(type(quantity, :decimal) * type(price, :decimal)),
      public?: true
  end

  relationships do
    belongs_to :order, App.Store.Order do
      allow_nil? false
    end
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
    type :order_item

    queries do
      list :list_order_items, :read, paginate_with: nil
    end
  end

  postgres do
    table "order_items"
    repo App.Repo
  end

  multitenancy do
    strategy :context
  end
end
