defmodule App.Store.OrderItemModifier do
  use Ash.Resource,
    domain: App.Store,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id

    attribute :quantity, :decimal, allow_nil?: false, public?: true
    attribute :price, :decimal, allow_nil?: false, public?: true
  end

  calculations do
    calculate :total, :decimal, expr(type(price, :decimal) * type(quantity, :decimal)),
      public?: true
  end

  relationships do
    belongs_to :order_item, App.Store.OrderItem do
      allow_nil? false
      public? true
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
    type :order_item_modifier

    queries do
      get :order_item_modifier, :read
      list :order_item_modifiers, :read, paginate_with: nil
    end
  end

  postgres do
    table "order_item_modifiers"
    repo App.Repo
  end
end
