defmodule QuestionBank.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end

  def down do
    drop unique_index(:users, [:email])
    drop table(:users)
  end
end
