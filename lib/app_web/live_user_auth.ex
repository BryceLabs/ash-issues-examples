defmodule AppWeb.LiveUserAuth do
  @moduledoc """
  Helpers for authenticating users in liveviews
  """

  import Phoenix.Component
  use AppWeb, :verified_routes

  def on_mount(:live_user_optional, _params, session, socket) do
    if socket.assigns[:current_user] do
      {:cont, assign(socket, current_tenant: session["tenant"])}
    else
      {:cont,
       socket
       |> assign(current_user: nil)
       |> assign(current_tenant: session["tenant"])}
    end
  end

  def on_mount(:live_user_required, _params, session, socket) do
    if socket.assigns[:current_user] do
      {:cont, assign(socket, current_tenant: session["tenant"])}
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/sign-in")}
    end
  end

  def on_mount(:live_no_user, _params, session, socket) do
    IO.puts("ON MOUNT - NO USER")
    IO.inspect(session, label: "Session")

    if socket.assigns[:current_user] do
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/")}
    else
      {:cont,
       socket
       |> assign(current_user: nil)
       |> assign(current_tenant: session["tenant"])}
    end
  end
end
