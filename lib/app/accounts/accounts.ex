defmodule App.Accounts do
  use Ash.Domain,
    extensions: [
      AshGraphql.Domain
    ]

  graphql do
    authorize? true
  end

  resources do
    resource App.Accounts.Company
    resource App.Accounts.User
    resource App.Accounts.Token
  end
end
