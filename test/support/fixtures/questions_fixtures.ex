defmodule QuestionBank.QuestionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `QuestionBank.Questions` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        category: "some category",
        choice_a: "some choice_a",
        choice_b: "some choice_b",
        choice_c: "some choice_c",
        choice_d: "some choice_d",
        correct_answer: "some correct_answer",
        difficulty_level: 42,
        question_text: "some question_text"
      })
      |> QuestionBank.Questions.create_question()

    question
  end
end
