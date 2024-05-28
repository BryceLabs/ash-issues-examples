defmodule App.Businesses.Category do
  use Ash.Resource,
    domain: App.Businesses,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id, public?: true

    attribute :name, :string, allow_nil?: false, public?: true
    attribute :default_lodging_tax_rate, :decimal, allow_nil?: false, public?: true
    attribute :default_retail_tax_rate, :decimal, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :location, App.Businesses.Location, allow_nil?: false, public?: true
    has_many :payments, App.Businesses.Payment, public?: true
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
    type :category

    queries do
      list :list_categories, :read, paginate_with: nil
      get :get_category, :read
    end

    mutations do
    end
  end

  postgres do
    table "categories"
    repo App.Repo
  end

  multitenancy do
    strategy :context
  end
end
