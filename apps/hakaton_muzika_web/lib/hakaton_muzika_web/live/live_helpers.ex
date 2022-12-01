defmodule HakatonMuzikaWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  def assign_current_user(socket, session) do
    assign_new(socket, :current_user, 
      fn -> 
        case Map.fetch(session, "user_token") do
          {:ok, token} -> 
            HakatonMuzika.Accounts.get_user_by_session_token(token)
          :error -> 
            nil
        end
    end)
  end
  def cut_text(text) do
    if String.length(text) < 36 do
      text
    else
      String.slice(text, 0, 36) <> " ..."
    end
  end

  def duration_str(duration) do
    duration_s = floor(duration / 1000)
    mins = floor(duration_s / 60)
    seconds =
      rem(duration_s, 60)
      |> pad()
    "#{mins}:#{seconds}"
  end

  def pad(x) do
    x
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

end
