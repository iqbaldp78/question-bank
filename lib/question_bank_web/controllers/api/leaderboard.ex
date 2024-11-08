defmodule QuestionBankWeb.API.Leaderboard do
  alias QuestionBank.Leaderboards.Leaderboard
  alias QuestionBank.Leaderboard

  # Update or create a leaderboard entry with incremented score
  def update_leaderboard_score(user_id, is_correct) do
    Leaderboard.update_leaderboard_score(user_id, is_correct)
  end
end
