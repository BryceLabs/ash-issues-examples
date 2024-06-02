defmodule App.Accounts.User do
  use Ash.Resource,
    domain: App.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshAuthentication,
      AshGraphql.Resource
    ]

  attributes do
    uuid_primary_key :id, public?: true
    attribute :email, :ci_string, allow_nil?: false, public?: true
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true, public?: false
  end

  authentication do
    domain App.Accounts

    strategies do
      password :password do
        identity_field :email
        sign_in_tokens_enabled? true
        confirmation_required? false

        resettable do
          sender App.Accounts.User.Senders.SendPasswordResetEmail
        end
      end
    end

    tokens do
      enabled? true
      token_resource App.Accounts.Token
      signing_secret App.Accounts.Secrets
    end
  end

  graphql do
    type :user

    queries do
      read_one :sign_in_with_password, :sign_in_with_password do
        as_mutation? true
        type_name :user_with_metadata
      end
    end

    mutations do
      update :update_user, :update
    end
  end

  postgres do
    table "users"
    repo App.Repo
  end

  identities do
    identity :unique_email, [:email]
  end

  multitenancy do
    strategy :context
  end

  # If using policies, add the following bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
