defmodule HakatonMuzikaWeb.Playlist.OneLive do
  require Logger
  use HakatonMuzikaWeb, :live_view

  alias HakatonMuzika.Playlists
  def mount(%{"id" => id}, session, socket) do
    playlist = Playlists.get_playlist_preloaded!(id)
    {:ok, socket
      |> assign_playlist(playlist)
      |> assign_current_user(session)
    }
  end

  def assign_playlist(socket, playlist) do
    assign_new(socket, :playlist, fn -> playlist end)
  end

  def handle_event("delete", _unsigned_params, socket) do
    Playlists.delete_playlist(socket.assigns.playlist)
    {:noreply, redirect(socket, to: HakatonMuzikaWeb.Router.Helpers.list_path(socket, :index))}
  end

  def handle_event("remove_song", %{"song_id" => song_id}, socket) do
    Logger.alert(song_id)
    Logger.alert(socket.assigns.playlist.id)
    Playlists.remove_song(socket.assigns.playlist, song_id)
    {:noreply, socket} 
  end

end
