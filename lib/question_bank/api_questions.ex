defmodule QuestionBank.ApiQuestions do
  @moduledoc """
  The ApiQuestions context.
  """

  import Ecto.Query, warn: false
  alias QuestionBank.Repo

  alias QuestionBank.ApiQuestions.Question

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    Repo.all(Question)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """

  # def get_question!(id), do: Repo.get!(Question, id)

  def get_question!(id) do
    # Ensure the id is an integer
    sql = "
      WITH prev AS (
          SELECT id AS prev_id
          FROM questions
          WHERE id < $1
          ORDER BY id DESC
          LIMIT 1
      ),
      next AS (
          SELECT id AS next_id
          FROM questions
          WHERE id > $1
          ORDER BY id ASC
          LIMIT 1
      )
      SELECT
          q.*,
          (SELECT prev_id FROM prev) AS prev_id,
          (SELECT next_id FROM next) AS next_id
          from questions q where id = $1;
    "

    case Ecto.Adapters.SQL.query(Repo, sql, [id]) do
      {:ok, %{rows: [row]}} ->
        # Convert the row list to a map
        question_map = %{
          id: Enum.at(row, 0),
          question_text: Enum.at(row, 1),
          choice_a: Enum.at(row, 2),
          choice_b: Enum.at(row, 3),
          choice_c: Enum.at(row, 4),
          choice_d: Enum.at(row, 5),
          correct_answer: Enum.at(row, 6),
          category: Enum.at(row, 7),
          difficulty_level: Enum.at(row, 8),
          inserted_at: Enum.at(row, 9),
          updated_at: Enum.at(row, 10),
          prev_id: Enum.at(row, 11),
          next_id: Enum.at(row, 12)
        }

        {:ok, Repo.load(Question, question_map)}

      {:ok, _} ->
        {:error, :not_found}

      {:error, reason} ->
        raise reason
    end
  end

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{data: %Question{}}

  """
  def change_question(%Question{} = question, attrs \\ %{}) do
    Question.changeset(question, attrs)
  end
end
