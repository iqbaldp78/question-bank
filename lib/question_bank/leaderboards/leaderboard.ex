defmodule QuestionBank.Leaderboards.Leaderboard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leaderboards" do
    field :score, :integer, default: 0
    belongs_to :user, QuestionBank.Accounts.User

    timestamps()
  end

  def changeset(leaderboard, attrs) do
    leaderboard
    |> cast(attrs, [:user_id, :score])
    |> validate_required([:user_id, :score])
  end
end
