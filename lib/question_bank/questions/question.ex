defmodule QuestionBank.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :category, :string
    field :question_text, :string
    field :choice_a, :string
    field :choice_b, :string
    field :choice_c, :string
    field :choice_d, :string
    field :correct_answer, :string
    field :difficulty_level, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question_text, :choice_a, :choice_b, :choice_c, :choice_d, :correct_answer, :category, :difficulty_level])
    |> validate_required([:question_text, :choice_a, :choice_b, :choice_c, :choice_d, :correct_answer, :category, :difficulty_level])
  end
end
