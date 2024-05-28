defmodule AppWeb.Plugs.InspectPlug do
  def init(options), do: options

  def call(conn, _opts) do
    IO.puts("-----INSPECT-----")
    # IO.inspect(conn, label: "Conn")
    IO.inspect(Ash.PlugHelpers.get_tenant(conn), label: "Tenant")
    conn
  end
end
