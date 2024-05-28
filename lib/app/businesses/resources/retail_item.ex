defmodule App.Businesses.RetailItem do
  use Ash.Resource,
    domain: App.Businesses,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id, public?: true

    attribute :name, :string, allow_nil?: true, public?: true
    attribute :price, :decimal, allow_nil?: false, public?: true
    attribute :quantity, :decimal, allow_nil?: false, public?: true
    attribute :tax_rate, :boolean, allow_nil?: false, public?: true
  end

  calculations do
    calculate :subtotal, :decimal, expr(price * quantity), public?: true
    calculate :tax, :decimal, expr(subtotal * tax_rate), public?: true
    calculate :total, :decimal, expr(subtotal + tax), public?: true
  end

  relationships do
    belongs_to :payment, App.Businesses.Payment, allow_nil?: false, public?: true
  end

  code_interface do
    define :create, action: :create
    define :read_all, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
  end

  actions do
    default_accept :*
    defaults [:create, :read, :update, :destroy]
  end

  graphql do
    type :retail_item

    queries do
    end

    mutations do
    end
  end

  postgres do
    table "retail_items"
    repo App.Repo
  end

  multitenancy do
    strategy :context
  end
end
