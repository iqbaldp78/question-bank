defmodule QuestionBankWeb.API.QuestionJSON do
  alias QuestionBank.ApiQuestions.Question
  require Logger

  @doc """
  Renders a list of questions.
  """
  def index(%{questions: questions}) do
    Logger.info("Rendering questions: #{inspect(questions)}")
    %{data: for(question <- questions, do: data(question))}
  end

  @doc """
  Renders a single question.
  """
  def show(%{question: question}) do
    %{data: data(question), message: "Question found"}
  end

  defp data(%Question{} = question) do
    %{
      id: question.id,
      question_text: question.question_text,
      choice_a: question.choice_a,
      choice_b: question.choice_b,
      choice_c: question.choice_c,
      choice_d: question.choice_d,
      correct_answer: question.correct_answer,
      category: question.category,
      difficulty_level: question.difficulty_level
    }
  end
end
