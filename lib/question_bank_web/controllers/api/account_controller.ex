defmodule QuestionBankWeb.API.AccountController do
  use QuestionBankWeb, :controller
  require Logger

  alias QuestionBank.Accounts

  def register_user(conn, %{"email" => email, "password" => password}) do
    case Accounts.create_user(%{"email" => email, "password" => password}) do
      {:ok, user} ->
        Logger.info("User #{user.email} registered")

        conn
        |> put_status(:created)
        |> json(%{status_code: "201", message: "User registered successfully"})

      {:error, reason} ->
        Logger.info("Failed registration attempt for #{reason}")

        conn
        |> put_status(:unauthorized)
        |> json(%{status_code: "401", message: "Invalid email or password"})
    end
  end
end
