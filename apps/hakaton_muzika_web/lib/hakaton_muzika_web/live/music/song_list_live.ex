defmodule HakatonMuzikaWeb.Music.SongListLive do
  use HakatonMuzikaWeb, :live_view
  alias HakatonMuzika.Music

  def mount(params, session, socket) do
    {:ok, assign_playlists(socket, session)}
  end
  
  def handle_event("play", %{"song_id" => id}, socket) do
    song = Music.get_song_with_album_details!(id)
    HakatonMuzikaWeb.PlayerState.add_current_song(song)
    {:noreply, socket}
  end
end
