defmodule App.Repo do
  use AshPostgres.Repo,
    otp_app: :app

  def installed_extensions do
    ["uuid-ossp", "citext", "ash-functions"]
  end

  def all_tenants do
    for company <- App.Accounts.Company.read_all!() do
      company.domain
    end
  end
end
