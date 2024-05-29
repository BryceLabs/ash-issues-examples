defmodule App.Accounts.User.Senders.SendPasswordResetEmail do
  @moduledoc """
  Sends a password reset email
  """
  use AshAuthentication.Sender
  use AppWeb, :verified_routes

  @impl AshAuthentication.Sender
  def send(user, token, _) do
    App.Accounts.Emails.deliver_reset_password_instructions(
      user,
      url(~p"/password-reset/#{token}")
      |> add_subdomain(user.__meta__.prefix)
    )
  end

  defp add_subdomain(url, subdomain) do
    # Split the URL into parts
    [protocol, rest] = String.split(url, "://")

    # Add the subdomain to the URL
    new_url = protocol <> "://" <> subdomain <> "." <> rest

    new_url
  end
end
