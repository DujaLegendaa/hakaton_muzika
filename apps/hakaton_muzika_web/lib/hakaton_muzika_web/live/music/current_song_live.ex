defmodule HakatonMuzikaWeb.Music.CurrentSongLive do
  use HakatonMuzikaWeb, :live_view
  require Logger
  
  def mount(_params, _session, socket) do
    if connected?(socket) do
      HakatonMuzikaWeb.Endpoint.subscribe("player_state")
    end
    {:ok, 
      socket
      |> assign_new(:current_song, fn -> HakatonMuzikaWeb.PlayerState.get_current_song() end)
    }
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "current_song", payload: song}, socket) do
    {:noreply, 
      socket
      |> assign(:current_song, song)
      |> push_event("current_song", %{id: song.song.id})
    }
  end

end
