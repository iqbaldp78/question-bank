defmodule QuestionBankWeb.API.QuestionControllerTest do
  use QuestionBankWeb.ConnCase

  import QuestionBank.ApiQuestionsFixtures

  alias QuestionBank.ApiQuestions.Question

  @create_attrs %{
    category: "some category",
    question_text: "some question_text",
    choice_a: "some choice_a",
    choice_b: "some choice_b",
    choice_c: "some choice_c",
    choice_d: "some choice_d",
    correct_answer: "some correct_answer",
    difficulty_level: 42
  }
  @update_attrs %{
    category: "some updated category",
    question_text: "some updated question_text",
    choice_a: "some updated choice_a",
    choice_b: "some updated choice_b",
    choice_c: "some updated choice_c",
    choice_d: "some updated choice_d",
    correct_answer: "some updated correct_answer",
    difficulty_level: 43
  }
  @invalid_attrs %{category: nil, question_text: nil, choice_a: nil, choice_b: nil, choice_c: nil, choice_d: nil, correct_answer: nil, difficulty_level: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all questions", %{conn: conn} do
      conn = get(conn, ~p"/api/api/questions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create question" do
    test "renders question when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/api/questions", question: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/api/questions/#{id}")

      assert %{
               "id" => ^id,
               "category" => "some category",
               "choice_a" => "some choice_a",
               "choice_b" => "some choice_b",
               "choice_c" => "some choice_c",
               "choice_d" => "some choice_d",
               "correct_answer" => "some correct_answer",
               "difficulty_level" => 42,
               "question_text" => "some question_text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/api/questions", question: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update question" do
    setup [:create_question]

    test "renders question when data is valid", %{conn: conn, question: %Question{id: id} = question} do
      conn = put(conn, ~p"/api/api/questions/#{question}", question: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/api/questions/#{id}")

      assert %{
               "id" => ^id,
               "category" => "some updated category",
               "choice_a" => "some updated choice_a",
               "choice_b" => "some updated choice_b",
               "choice_c" => "some updated choice_c",
               "choice_d" => "some updated choice_d",
               "correct_answer" => "some updated correct_answer",
               "difficulty_level" => 43,
               "question_text" => "some updated question_text"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn = put(conn, ~p"/api/api/questions/#{question}", question: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete question" do
    setup [:create_question]

    test "deletes chosen question", %{conn: conn, question: question} do
      conn = delete(conn, ~p"/api/api/questions/#{question}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/api/questions/#{question}")
      end
    end
  end

  defp create_question(_) do
    question = question_fixture()
    %{question: question}
  end
end
