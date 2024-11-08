defmodule QuestionBankWeb.API.SessionController do
  use QuestionBankWeb, :controller
  alias QuestionBank.Accounts

  alias QuestionBankWeb.Auth.Jwt
  require Logger

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        Logger.info("User #{user.email} authenticated")
        token = Jwt.generate_token(user)
        json(conn, %{token: token})

      {:error, reason} ->
        Logger.info("Failed authentication attempt for #{reason}")

        conn
        |> put_status(:unauthorized)
        |> json(%{status_code: "401", message: "Invalid email or password"})
    end
  end
end
