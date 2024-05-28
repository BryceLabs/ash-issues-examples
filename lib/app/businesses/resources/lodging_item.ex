defmodule App.Businesses.LodgingItem do
  use Ash.Resource,
    domain: App.Businesses,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id, public?: true

    attribute :name, :string, allow_nil?: true, public?: true
    attribute :rate, :decimal, allow_nil?: false, public?: true
    attribute :check_in_date, :date, allow_nil?: false, public?: true
    attribute :check_out_date, :date, allow_nil?: false, public?: true
    attribute :tax_rate, :decimal, allow_nil?: false, public?: true
  end

  calculations do
    calculate :quantity, :decimal, expr(checkout_date - checkin_date), public?: true
    calculate :subtotal, :decimal, expr(rate * quantity), public?: true
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
    type :lodging_item

    queries do
    end

    mutations do
    end
  end

  postgres do
    table "lodging_items"
    repo App.Repo
  end

  multitenancy do
    strategy :context
  end
end
