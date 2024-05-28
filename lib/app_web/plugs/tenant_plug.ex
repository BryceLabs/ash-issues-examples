defmodule AppWeb.Plugs.TenantPlug do
  def init(options), do: options

  def call(conn, _opts) do
    IO.inspect(conn.host)

    tenant = get_top_level_subdomain(conn.host)

    IO.inspect("Set tenant to #{tenant}")

    conn
    |> Ash.PlugHelpers.set_tenant(tenant)
    |> Plug.Conn.put_session("tenant", tenant)
  end

  defp get_top_level_subdomain(host) do
    host_parts = String.split(host, ".")

    case host_parts do
      [subdomain | _rest] when subdomain != "localhost" and length(host_parts) > 1 -> subdomain
      ["localhost"] -> nil
      [subdomain, "localhost"] -> subdomain
      _ -> nil
    end
  end
end
