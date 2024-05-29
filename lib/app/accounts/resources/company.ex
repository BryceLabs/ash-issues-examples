defmodule App.Accounts.Company do
  use Ash.Resource,
    domain: App.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id, public?: true

    attribute :name, :string, allow_nil?: false, public?: true
    attribute :domain, :string, allow_nil?: false, public?: true
  end

  code_interface do
    define :create
    define :read_all, action: :read
    define :update
    define :destroy
    # define :get_by_id, args: [:id], action: :by_id
    define :get_by_domain, args: [:domain], action: :by_domain
  end

  actions do
    default_accept :*
    defaults [:create, :read, :update, :destroy]

    # read :by_id do
    #   primary? false
    #   # This action has one argument :id of type :uuid
    #   argument :id, :uuid, allow_nil?: false
    #   # Tells us we expect this action to return a single result
    #   get? true
    #   # Filters the `:id` given in the argument
    #   # against the `id` of each element in the resource
    #   filter expr(id == ^arg(:id))
    # end

    # # TODO: Can be replaced by special code interface?
    read :by_domain do
      primary? false

      argument :domain, :string, allow_nil?: false, public?: false

      get? true

      filter expr(domain == ^arg(:domain))
    end
  end

  identities do
    identity :unique_domain, [:domain]
  end

  graphql do
    type :company

    queries do
      list :list_companies, :read, paginate_with: nil
      get :company_by_id, :read
      get :company_by_domain, :read, identity: :unique_domain
    end

    mutations do
    end
  end

  postgres do
    table "companies"
    repo App.Repo

    manage_tenant do
      template [:domain]
    end
  end
end
