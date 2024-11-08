defmodule QuestionBank.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt
  require Logger

  schema "users" do
    field :email, :string
    field :password_hash, :string, redact: true
    field :password, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 6)
    |> put_password_hash()
    |> validate_required([:password_hash])
    |> unique_constraint(:email)
  end

  defp put_password_hash(changeset) do
    if password = get_change(changeset, :password) do
      hash = Bcrypt.hash_pwd_salt(password)
      changeset = put_change(changeset, :password_hash, hash)
      Logger.info("Password hash created1: #{inspect(changeset)}")
      changeset
    else
      changeset
    end
  end
end
