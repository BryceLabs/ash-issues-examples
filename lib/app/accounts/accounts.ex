defmodule App.Accounts do
  use Ash.Domain

  resources do
    resource App.Accounts.Company
    resource App.Accounts.User
    resource App.Accounts.Token
  end
end
