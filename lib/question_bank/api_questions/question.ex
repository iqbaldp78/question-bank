defmodule QuestionBank.ApiQuestions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :id,
             :next_id,
             :prev_id,
             :category,
             :question_text,
             :choice_a,
             :choice_b,
             :choice_c,
             :choice_d,
             :correct_answer,
             :difficulty_level,
             :inserted_at,
             :updated_at
           ]}
  schema "questions" do
    field :next_id, :integer
    field :prev_id, :integer
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
    |> cast(attrs, [
      :question_text,
      :choice_a,
      :choice_b,
      :choice_c,
      :choice_d,
      :correct_answer,
      :category,
      :difficulty_level,
      :next_id,
      :prev_id
    ])
    |> validate_required([
      :question_text,
      :choice_a,
      :choice_b,
      :choice_c,
      :choice_d,
      :correct_answer,
      :category,
      :difficulty_level
    ])
  end
end
