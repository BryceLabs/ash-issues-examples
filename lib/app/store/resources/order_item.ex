defmodule App.Store.OrderItem do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id

    attribute :product_name, :string, allow_nil?: false
    attribute :size_name, :string, allow_nil?: true

    attribute :quantity, :decimal, allow_nil?: false
    attribute :price, :decimal, allow_nil?: false
  end

  calculations do
    calculate :subtotal, :string, expr(quantity * price)
  end

  relationships do
    belongs_to :order, App.Store.Order do
      allow_nil? false
      attribute_writable? true
    end
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

  postgres do
    table "order_items"
    repo App.Repo
  end
end
