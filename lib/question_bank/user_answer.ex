defmodule QuestionBank.UserAnswer do
  @moduledoc """
  The UserAnswer context.
  """

  import Ecto.Query, warn: false
  alias QuestionBank.Repo
  alias QuestionBank.UserAnswer.UserAnswer

  @doc """
  create a user answer
  """
  def create_user_answer(%{
        question_id: question_id,
        user_id: user_id,
        answer: answer,
        is_correct: is_correct
      }) do
    %UserAnswer{}
    |> UserAnswer.changeset(%{
      question_id: question_id,
      user_id: user_id,
      selected_answer: answer,
      is_correct: is_correct
    })
    |> Repo.insert()
  end
end
