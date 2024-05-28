defmodule App.Businesses.Transaction do
  use Ash.Resource,
    domain: App.Businesses,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id, public?: true
    attribute :staff_id, :string, allow_nil?: true, public?: true

    attribute :type, :atom do
      allow_nil? false
      public? true

      constraints one_of: [
                    :card_sale,
                    :card_refund,
                    :card_void,
                    :card_auth
                  ]
    end

    create_timestamp :created_at
    update_timestamp :updated_at
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
    type :transaction

    queries do
      list :list_transactions, :read, paginate_with: nil
      get :get_transaction, :read
    end

    mutations do
      create :create_transaction, :create
    end
  end

  postgres do
    table "transactions"
    repo App.Repo
  end

  multitenancy do
    strategy :context
  end
end
