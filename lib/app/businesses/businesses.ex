defmodule App.Businesses do
  use Ash.Domain,
    extensions: [
      AshGraphql.Domain
    ]

  graphql do
    authorize? true
  end

  resources do
    resource App.Businesses.Category
    resource App.Businesses.Location
    resource App.Businesses.LodgingItem
    resource App.Businesses.Payment
    resource App.Businesses.RetailItem
    resource App.Businesses.Transaction
  end
end
