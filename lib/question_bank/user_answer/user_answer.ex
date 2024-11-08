defmodule QuestionBank.UserAnswer.UserAnswer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_answers" do
    field :user_id, :integer
    field :question_id, :integer
    field :selected_answer, :string
    field :is_correct, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user_answer, attrs) do
    user_answer
    |> cast(attrs, [:user_id, :question_id, :selected_answer, :is_correct])
    |> validate_required([:user_id, :question_id, :selected_answer, :is_correct])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:question_id)
  end
end
