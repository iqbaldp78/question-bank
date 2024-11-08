defmodule QuestionBank.QuestionsTest do
  use QuestionBank.DataCase

  alias QuestionBank.Questions

  describe "questions" do
    alias QuestionBank.Questions.Question

    import QuestionBank.QuestionsFixtures

    @invalid_attrs %{category: nil, question_text: nil, choice_a: nil, choice_b: nil, choice_c: nil, choice_d: nil, correct_answer: nil, difficulty_level: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Questions.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Questions.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{category: "some category", question_text: "some question_text", choice_a: "some choice_a", choice_b: "some choice_b", choice_c: "some choice_c", choice_d: "some choice_d", correct_answer: "some correct_answer", difficulty_level: 42}

      assert {:ok, %Question{} = question} = Questions.create_question(valid_attrs)
      assert question.category == "some category"
      assert question.question_text == "some question_text"
      assert question.choice_a == "some choice_a"
      assert question.choice_b == "some choice_b"
      assert question.choice_c == "some choice_c"
      assert question.choice_d == "some choice_d"
      assert question.correct_answer == "some correct_answer"
      assert question.difficulty_level == 42
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{category: "some updated category", question_text: "some updated question_text", choice_a: "some updated choice_a", choice_b: "some updated choice_b", choice_c: "some updated choice_c", choice_d: "some updated choice_d", correct_answer: "some updated correct_answer", difficulty_level: 43}

      assert {:ok, %Question{} = question} = Questions.update_question(question, update_attrs)
      assert question.category == "some updated category"
      assert question.question_text == "some updated question_text"
      assert question.choice_a == "some updated choice_a"
      assert question.choice_b == "some updated choice_b"
      assert question.choice_c == "some updated choice_c"
      assert question.choice_d == "some updated choice_d"
      assert question.correct_answer == "some updated correct_answer"
      assert question.difficulty_level == 43
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_question(question, @invalid_attrs)
      assert question == Questions.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Questions.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Questions.change_question(question)
    end
  end
end
