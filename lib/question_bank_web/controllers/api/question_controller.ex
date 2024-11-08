defmodule QuestionBankWeb.API.QuestionController do
  use QuestionBankWeb, :controller

  alias QuestionBank.ApiQuestions
  alias QuestionBank.ApiQuestions.Question
  require Logger

  action_fallback QuestionBankWeb.FallbackController

  def index(conn, _params) do
    questions = ApiQuestions.list_questions()
    render(conn, :index, questions: questions)
  end

  def create(conn, %{"question" => question_params}) do
    with {:ok, %Question{} = question} <- ApiQuestions.create_question(question_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", ~p"/api/questions/#{question}")
      |> render(:show, question: question)
    end
  end

  def show(conn, %{"id" => id}) do
    claims = conn.assigns[:current_user]
    Logger.info("Claims: #{inspect(claims)}")
    id = String.to_integer(id)
    question = ApiQuestions.get_question!(id)
    Logger.info("Question found: #{inspect(question)}")

    conn
    |> put_status(:ok)
    |> json(%{status_code: "200", message: "Question retrieved successfully", data: question})
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = ApiQuestions.get_question!(id)

    with {:ok, %Question{} = question} <- ApiQuestions.update_question(question, question_params) do
      render(conn, :show, question: question)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = ApiQuestions.get_question!(id)

    with {:ok, %Question{}} <- ApiQuestions.delete_question(question) do
      send_resp(conn, :no_content, "")
    end
  end
end
