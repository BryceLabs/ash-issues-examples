defmodule App.Accounts.User do
  use Ash.Resource,
    domain: App.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
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
