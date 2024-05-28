defmodule App.Businesses.Location do
  use Ash.Resource,
    domain: App.Businesses,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id, public?: true

    attribute :name, :string, allow_nil?: false, public?: true
    attribute :address, :string, allow_nil?: false, public?: true
    attribute :city, :string, allow_nil?: false, public?: true
    attribute :state, :string, allow_nil?: false, public?: true
    attribute :zip, :string, allow_nil?: false, public?: true
    attribute :phone, :string, allow_nil?: false, public?: true
  end

  relationships do
    has_many :categories, App.Businesses.Category, public?: true
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
    type :location

    queries do
      list :list_locations, :read, paginate_with: nil
      get :get_location, :read
    end

    mutations do
    end
  end

  postgres do
    table "locations"
    repo App.Repo
  end

  multitenancy do
    strategy :context
  end
end
