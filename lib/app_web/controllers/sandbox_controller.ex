defmodule AppWeb.SandboxController do
  use AppWeb, :controller

  def sandbox(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :sandbox, layout: false)
  end
end
