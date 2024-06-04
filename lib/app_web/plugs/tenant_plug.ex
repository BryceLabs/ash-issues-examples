defmodule AppWeb.Plugs.TenantPlug do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    IO.inspect(conn.host)

    tenant =
      case get_req_header(conn, "tenant") do
        [tenant_header] ->
          tenant_header

        [] ->
          cond do
            conn.host == "localhost" ->
              nil

            String.ends_with?(conn.host, ".example.com") ->
              String.split(conn.host, ".") |> List.first()

            true ->
              conn.assigns[:current_tenant]
          end
      end

    IO.inspect("Set tenant to #{tenant}")

    conn
    |> Ash.PlugHelpers.set_tenant(tenant)
    |> put_session("tenant", tenant)
  end
end
