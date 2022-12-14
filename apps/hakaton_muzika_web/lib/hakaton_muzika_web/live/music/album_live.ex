defmodule HakatonMuzikaWeb.Music.AlbumLive do
  alias HakatonMuzika.Music
  alias Phoenix.LiveView.JS
  require Logger
  use HakatonMuzikaWeb, :live_view

  def mount(%{"id" => id}, session, socket) do
    album = Music.get_album_with_songs!(id)
    {:ok,
      socket
      |> assign_album(album)
      |> assign_playlists(session)
    }
  end

  def assign_album(socket, album) do
    assign_new(socket, :album, fn -> album end)
  end

  def handle_event("play", %{"song_id" => id}, socket) do
    song = Music.get_song_with_album_details!(id)
    HakatonMuzikaWeb.PlayerState.add_current_song(song)
    {:noreply, socket}
  end

  def handle_event("add-to-playlist", %{"playlist_id" => playlist_id, "song_id" => song_id}, socket) do
    # TODO optimize this call
    HakatonMuzika.Playlists.add_song(HakatonMuzika.Playlists.get_playlist!(playlist_id), HakatonMuzika.Music.get_song!(song_id))
    {:noreply, put_flash(socket, :info, "Successfully added to playlist")}
  end

end

  """
  def song_card(%{id: _, title: _, duration: _, track: _, album_name: _, album_cover: _, playlists: _} = assigns) do
~H"""
    <div class="relative">
      <div phx-click="play" phx-value-song_id={@id} class="flex justify-between m-0 p-3 rounded-xl hover:bg-neutral-900">
        <div class="flex gap-x-[1rem]">
          <img class="rounded-2xl w-[100px] lg:w-[200px]" src={HakatonMuzikaWeb.B3.get_url(@album_cover)} />
          <div class="flex flex-col justify-evenly">
            <p class="text-xl font-bold"><%= cut_text @title %></p>
            <p class="text-sm"><%= cut_text @album_name %></p>
            <div class="flex items-center">
              <FontAwesome.LiveView.icon name="guitar" type="solid" class="w-4 h-4 fill-slate-400"/>
              <p class="text-xs text-slate-400 font-semibold "><%= duration_str(@duration) %></p>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
