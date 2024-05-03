defmodule App.Repo do
  use AshPostgres.Repo,
    otp_app: :app

  def installed_extensions do
    ["uuid-ossp", "citext", "ash-functions"]
  end
end
