defmodule QuestionBankWeb.Auth.Jwt do
  @moduledoc """
  JWT utilities for encoding and decoding tokens.
  """

  @secret_key Application.compile_env(:question_bank, QuestionBankWeb.Auth, [])[:jwt_secret] ||
                "your_secret_key_here"
  # Expiration time in seconds (e.g., 1 hour = 3600 seconds)
  @expiration 3600

  alias JOSE.{JWK, JWT}

  # Generates a JWT bearer token for a user
  def generate_token(user) do
    claims = %{
      "sub" => user.id,
      "exp" => expiration_time(),
      "email" => user.email
    }

    # Sign and compact the token
    # Extract the compact token from the signed tuple
    # Converts the signed token to a compact format
    # Generate and compact the JWT token
    @secret_key
    |> JWK.from_oct()
    |> JWT.sign(%{"alg" => "HS256"}, claims)
    # Extract the compact token from the signed tuple
    |> elem(1)
    |> JOSE.JWS.compact()
    # Extract the compact token from the signed tuple
    |> elem(1)
  end

  # Verify and decode the JWT token
  def verify_token(token) do
    secret_key = JWK.from_oct(@secret_key)

    case JWT.verify_strict(secret_key, ["HS256"], token) do
      {true, %JWT{fields: claims}, _} -> {:ok, claims}
      _ -> :error
    end
  end

  # Generate expiration time for the token (1 hour from now)
  defp expiration_time do
    DateTime.utc_now() |> DateTime.add(@expiration, :second) |> DateTime.to_unix()
  end
end
