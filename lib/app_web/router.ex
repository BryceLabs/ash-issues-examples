defmodule AppWeb.Router do
  use AppWeb, :router

  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug AshPhoenix.SubdomainPlug, endpoint: AppWeb.Endpoint
    plug AppWeb.Plugs.TenantPlug
    plug :fetch_live_flash
    plug :put_root_layout, html: {AppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # Ash Authentication
    plug :load_from_session
    # plug AppWeb.Plugs.InspectPlug
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  #   # Ash Authentication
  #   plug :load_from_bearer
  # end

  scope "/", AppWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/sandbox", SandboxController, :sandbox

    # Ash Authentication Routes
    sign_in_route(
      on_mount: [{AppWeb.LiveUserAuth, :live_no_user}],
      overrides: [
        AppWeb.Auth.Overrides,
        AshAuthentication.Phoenix.Overrides.Default
      ]
    )

    # sign_in_route(register_path: "/register", reset_path: "/reset")

    sign_out_route AuthController
    auth_routes_for App.Accounts.User, to: AuthController

    reset_route overrides: [
                  AppWeb.Auth.Overrides,
                  AshAuthentication.Phoenix.Overrides.Default
                ]
  end

  pipeline :graphql do
    plug :fetch_session
    plug AshPhoenix.SubdomainPlug, endpoint: AppWeb.Endpoint
    plug AppWeb.Plugs.TenantPlug
    plug AshGraphql.Plug
  end

  scope "/" do
    pipe_through [:graphql]

    forward "/gql",
            Absinthe.Plug,
            schema: Module.concat(["App.GraphqlSchema"])

    forward "/playground",
            Absinthe.Plug.GraphiQL,
            schema: Module.concat(["App.GraphqlSchema"]),
            interface: :playground
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
