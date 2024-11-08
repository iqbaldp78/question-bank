defmodule QuestionBankWeb.QuestionControllerTest do
  use QuestionBankWeb.ConnCase

  import QuestionBank.QuestionsFixtures

  @create_attrs %{category: "some category", question_text: "some question_text", choice_a: "some choice_a", choice_b: "some choice_b", choice_c: "some choice_c", choice_d: "some choice_d", correct_answer: "some correct_answer", difficulty_level: 42}
  @update_attrs %{category: "some updated category", question_text: "some updated question_text", choice_a: "some updated choice_a", choice_b: "some updated choice_b", choice_c: "some updated choice_c", choice_d: "some updated choice_d", correct_answer: "some updated correct_answer", difficulty_level: 43}
  @invalid_attrs %{category: nil, question_text: nil, choice_a: nil, choice_b: nil, choice_c: nil, choice_d: nil, correct_answer: nil, difficulty_level: nil}

  describe "index" do
    test "lists all questions", %{conn: conn} do
      conn = get(conn, ~p"/questions")
      assert html_response(conn, 200) =~ "Listing Questions"
    end
  end

  describe "new question" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/questions/new")
      assert html_response(conn, 200) =~ "New Question"
    end
  end

  describe "create question" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/questions", question: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/questions/#{id}"

      conn = get(conn, ~p"/questions/#{id}")
      assert html_response(conn, 200) =~ "Question #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/questions", question: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Question"
    end
  end

  describe "edit question" do
    setup [:create_question]

    test "renders form for editing chosen question", %{conn: conn, question: question} do
      conn = get(conn, ~p"/questions/#{question}/edit")
      assert html_response(conn, 200) =~ "Edit Question"
    end
  end

  describe "update question" do
    setup [:create_question]

    test "redirects when data is valid", %{conn: conn, question: question} do
      conn = put(conn, ~p"/questions/#{question}", question: @update_attrs)
      assert redirected_to(conn) == ~p"/questions/#{question}"

      conn = get(conn, ~p"/questions/#{question}")
      assert html_response(conn, 200) =~ "some updated category"
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn = put(conn, ~p"/questions/#{question}", question: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Question"
    end
  end

  describe "delete question" do
    setup [:create_question]

    test "deletes chosen question", %{conn: conn, question: question} do
      conn = delete(conn, ~p"/questions/#{question}")
      assert redirected_to(conn) == ~p"/questions"

      assert_error_sent 404, fn ->
        get(conn, ~p"/questions/#{question}")
      end
    end
  end

  defp create_question(_) do
    question = question_fixture()
    %{question: question}
  end
end
