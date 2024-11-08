defmodule QuestionBank.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :question_text, :string
      add :choice_a, :string
      add :choice_b, :string
      add :choice_c, :string
      add :choice_d, :string
      add :correct_answer, :string
      add :category, :string
      add :difficulty_level, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
