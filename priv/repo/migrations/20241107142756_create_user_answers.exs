defmodule QuestionBank.Repo.Migrations.CreateUserAnswers do
  use Ecto.Migration

  def up do
    create table(:user_answers) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :question_id, references(:questions, on_delete: :delete_all), null: false
      add :selected_answer, :string, null: false
      add :is_correct, :boolean, default: false, null: false

      timestamps()
    end
  end

  def down do
    drop table(:user_answers)
  end
end
