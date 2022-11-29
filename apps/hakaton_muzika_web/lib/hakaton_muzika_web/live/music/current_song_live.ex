defmodule HakatonMuzikaWeb.Music.CurrentSongLive do
  use HakatonMuzikaWeb, :live_view
  require Logger
  
  def mount(params, session, socket) do
{:ok, socket}
  end

end
"""
  def mount(_params, _session, socket) do
    if connected?(socket) do
      HakatonMuzikaWeb.Endpoint.subscribe("player_state")
    end
    {:ok, 
      socket
      |> assign_new(:current_song, fn -> HakatonMuzikaWeb.PlayerState.get_current_song() end)
      |> assign_new(:playing, fn -> HakatonMuzikaWeb.PlayerState.get_playing() end)
    }
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "current_song", payload: song}, socket) do
    {:noreply, assign(socket, :current_song, song) |> assign(:playing, true)}
  end

  def handle_info(%{event: "continue_pause", payload: s}, socket) do
    {:noreply, assign(socket, :playing, s)} 
  end

  def handle_event("continue-pause", _, socket) do
    s = socket.assigns[:playing]
    if s do
      HakatonMuzikaWeb.PlayerState.pause()
    else 
      HakatonMuzikaWeb.PlayerState.continue()
    end
    {:noreply, socket}
  end

  def get_img() do
    img = Enum.random(["capy.jpg", "oak.jpg"])
  end
"""
