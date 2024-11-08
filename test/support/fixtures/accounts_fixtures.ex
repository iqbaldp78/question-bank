defmodule QuestionBank.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `QuestionBank.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        password_hash: "some password_hash"
      })
      |> QuestionBank.Accounts.create_user()

    user
  end
end
