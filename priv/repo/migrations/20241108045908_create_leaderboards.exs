defmodule QuestionBank.Repo.Migrations.CreateLeaderboards do
  use Ecto.Migration

  def up do
    create table(:leaderboards) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :score, :integer, default: 0, null: false

      timestamps()
    end
  end
end
