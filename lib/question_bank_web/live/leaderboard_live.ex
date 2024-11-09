defmodule QuestionBankWeb.LeaderboardLive do
  use QuestionBankWeb, :live_view
  alias QuestionBank.Leaderboard

  @impl true
  def mount(_params, _session, socket) do
    # Subscribe to leaderboard updates
    if connected?(socket), do: Phoenix.PubSub.subscribe(QuestionBank.PubSub, "leaderboard")

    leaderboard = Leaderboard.get_leaderboard_list(10)
    {:ok, assign(socket, leaderboard: leaderboard)}
  end

  @impl true
  def handle_info(:update_leaderboard, socket) do
    leaderboard = Leaderboard.get_leaderboard_list(10)
    {:noreply, assign(socket, leaderboard: leaderboard)}
  end

  # @impl true
  # def render(assigns) do
  #   ~H"""
  #   <div id="leaderboard">
  #     <h1>Leaderboard</h1>
  #     <ul>
  #       <%= for entry <- @leaderboard do %>
  #         <li><%= entry.user_id %>: <%= entry.score %></li>
  #       <% end %>
  #     </ul>
  #   </div>
  #   """
  # end
end
