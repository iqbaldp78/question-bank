defmodule QuestionBank.Repo do
  use Ecto.Repo,
    otp_app: :question_bank,
    adapter: Ecto.Adapters.Postgres
end
