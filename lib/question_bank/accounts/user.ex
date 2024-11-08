defmodule QuestionBank.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  schema "users" do
    field :email, :string
    field :password_hash, :string, redact: true
    field :password, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash])
    |> validate_required([:email, :password_hash])
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    if password = get_change(changeset, :password) do
      put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    else
      changeset
    end
  end
end
