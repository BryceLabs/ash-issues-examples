defmodule App.Store.Organization do
  use Ash.Resource,
    domain: App.Store,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id, public?: true
    attribute :name, :string, allow_nil?: false, public?: true
    attribute :subdomain, :string, allow_nil?: false, public?: true
  end

  code_interface do
    domain App.Store
    define :create
    define :read_all, action: :read
    define :update
    define :destroy
    define :get_by_id, args: [:id], action: :by_id
    define :get_by_subdomain, args: [:subdomain], action: :by_subdomain
  end

  actions do
    default_accept :*
    defaults [:create, :read, :update, :destroy]

    read :by_id do
      primary? false
      # This action has one argument :id of type :uuid
      argument :id, :uuid, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? true
      # Filters the `:id` given in the argument
      # against the `id` of each element in the resource
      filter expr(id == ^arg(:id))
    end

    read :by_subdomain do
      primary? false
      # This action has one argument :subdomain of type :string
      argument :subdomain, :string, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? true
      # Filters the `:id` given in the argument
      # against the `id` of each element in the resource
      filter expr(subdomain == ^arg(:subdomain))
    end
  end

  graphql do
    type :organization

    queries do
      list :organizations, :read, paginate_with: nil
    end
  end

  identities do
    identity :unique_subdomain, [:subdomain]
  end

  postgres do
    table "organizations"
    repo App.Repo

    manage_tenant do
      template [:subdomain]
    end
  end
end
