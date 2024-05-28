defmodule App.Businesses.Payment do
  use Ash.Resource,
    domain: App.Businesses,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id, public?: true
    attribute :folio_number, :string, allow_nil?: true, public?: true

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  aggregates do
    sum :lodging_subtotal, :lodging_items, :subtotal, public?: true
    sum :lodging_tax, :lodging_items, :tax, public?: true
    sum :lodging_total, :lodging_items, :total, public?: true

    sum :retail_subtotal, :retail_items, :subtotal, public?: true
    sum :retail_tax, :retail_items, :tax, public?: true
    sum :retail_total, :retail_items, :total, public?: true
  end

  calculations do
    calculate :total, :decimal, expr(lodging_total + retail_total), public?: true
  end

  relationships do
    belongs_to :category, App.Businesses.Category, allow_nil?: false, public?: true
    has_many :lodging_items, App.Businesses.LodgingItem, public?: true
    has_many :retail_items, App.Businesses.RetailItem, public?: true
    has_many :transactions, App.Businesses.Transaction, public?: true
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
    type :payment

    queries do
      list :list_payments, :read, paginate_with: nil
      get :get_payment, :read
    end

    mutations do
      create :create_payment, :create
    end
  end

  postgres do
    table "payments"
    repo App.Repo
  end

  multitenancy do
    strategy :context
  end
end
