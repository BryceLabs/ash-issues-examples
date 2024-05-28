defmodule App.Accounts.Token do
  use Ash.Resource,
    domain: App.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshAuthentication.TokenResource,
      AshGraphql.Resource
    ]

  token do
    domain App.Accounts
  end

  graphql do
    type :token

    queries do
    end

    mutations do
    end
  end

  postgres do
    table "tokens"
    repo App.Repo
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
