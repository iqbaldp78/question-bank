defmodule QuestionBank.Leaderboard do
  import Ecto.Query, warn: false

  alias QuestionBank.Repo

  alias QuestionBank.Leaderboards.Leaderboard

  def update_leaderboard_score(user_id, is_correct) do
    leaderboard_entry = get_leaderboard(user_id) || %Leaderboard{user_id: user_id, score: 0}
    updated_score = calculate_new_score(leaderboard_entry.score, is_correct)
    changeset = Ecto.Changeset.change(leaderboard_entry, score: updated_score)

    case Repo.insert_or_update(changeset) do
      {:ok, _entry} ->
        broadcast_leaderboard_update()
        {:ok, "Leaderboard score updated successfully"}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def get_leaderboard(user_id) do
    Repo.get_by(Leaderboard, user_id: user_id)
  end

  defp calculate_new_score(current_score, is_correct) do
    case {current_score, is_correct} do
      {0, false} -> 0
      {_, false} -> current_score - 1
      {_, true} -> current_score + 1
    end
  end

  def get_leaderboard_list(limit \\ 10) do
    Leaderboard
    |> order_by(desc: :score)
    |> limit(^limit)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  defp broadcast_leaderboard_update do
    Phoenix.PubSub.broadcast(QuestionBank.PubSub, "leaderboard", :update_leaderboard)
  end
end
