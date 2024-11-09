defmodule QuestionBankWeb.Router do
  use QuestionBankWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {QuestionBankWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug QuestionBankWeb.Plugs.AuthPlug
  end

  # HTML routes (for the web interface)
  scope "/", QuestionBankWeb do
    pipe_through :browser
    resources "/questions", QuestionController
  end

  # API routes (for the JSON API)
  scope "/api", QuestionBankWeb.API, as: :api do
    pipe_through [:api, :authenticated]

    # Get all questions (index)
    get "/questions", QuestionController, :index

    # Get a single question (show)
    get "/questions/:id", QuestionController, :show

    # Create a new question (create)
    post "/questions", QuestionController, :create

    # Update a question (update)
    put "/questions/:id", QuestionController, :update

    # Delete a question (delete)
    delete "/questions/:id", QuestionController, :delete
  end

  scope "/api/auth", QuestionBankWeb.API, as: :api do
    pipe_through :api

    # Login (create session)
    post "/login", SessionController, :create
    post "/register", AccountController, :register_user
  end

  scope "/api/user", QuestionBankWeb.API, as: :api do
    pipe_through [:api, :authenticated]

    # Login (create session)
    post "/answer", UserAnswerController, :create_user_answer
  end

  scope "/", QuestionBankWeb do
    pipe_through :browser

    live "/leaderboard", LeaderboardLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", QuestionBankWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:question_bank, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: QuestionBankWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
