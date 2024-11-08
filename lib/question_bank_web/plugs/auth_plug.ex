defmodule QuestionBankWeb.Plugs.AuthPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias QuestionBankWeb.Auth.Jwt

  def init(default), do: default

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case Jwt.verify_token(token) do
          {:ok, claims} ->
            assign(conn, :current_user, claims)

          :error ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "Unauthorized"})
            |> halt()
        end

      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unauthorized"})
        |> halt()
    end
  end
end
