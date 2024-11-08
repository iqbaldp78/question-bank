defmodule QuestionBankWeb.API.UserAnswerController do
  use QuestionBankWeb, :controller
  alias QuestionBank.UserAnswer
  alias QuestionBank.ApiQuestions
  alias QuestionBank.ApiQuestions.Question
  alias QuestionBankWeb.API.Leaderboard

  require Logger

  def create_user_answer(conn, %{"question_id" => question_id, "answer" => answer}) do
    with {:ok, %Question{} = question} <- ApiQuestions.get_question!(question_id),
         claims <- conn.assigns[:current_user],
         user_id <- claims["sub"] do
      Logger.info("User #{user_id} answering question #{inspect(question)}")
      is_correct = answer == question.correct_answer

      case UserAnswer.create_user_answer(%{
             question_id: question_id,
             user_id: user_id,
             answer: answer,
             is_correct: is_correct
           }) do
        {:ok, _user_answer} ->
          # TODO: Update user's score
          handle_correct_answer(user_id, is_correct)

          conn
          |> put_status(:created)
          |> json(%{status_code: "201", message: "Answer submitted successfully"})

        {:error, reason} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{status_code: "400", message: reason})
      end
    else
      {:error, reason} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Question not found: #{reason}"})
    end
  end

  defp handle_correct_answer(user_id, is_correct) do
    # TODO: Update user's score in the leaderboard
    Logger.info("User #{user_id} answered correctly")

    with {:ok, message} <- Leaderboard.update_leaderboard_score(user_id, is_correct) do
      Logger.info(message)
    else
      {:error, changeset} ->
        Logger.error("Failed to update leaderboard: #{inspect(changeset.errors)}")
    end
  end
end
