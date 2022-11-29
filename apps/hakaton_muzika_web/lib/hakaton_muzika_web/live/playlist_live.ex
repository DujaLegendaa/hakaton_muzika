defmodule HakatonMuzikaWeb.PlaylistLive do
  use HakatonMuzikaWeb, :live_view

  alias HakatonMuzika.Playlists
  def mount(%{"id" => id}, _session, socket) do
    playlist = Playlists.get_playlist_with_songs!(id)
    {:ok, socket
      |> assign_playlist(playlist)}
  end

  def assign_playlist(socket, playlist) do
    assign_new(socket, :playlist, fn -> playlist end)
  end

end
