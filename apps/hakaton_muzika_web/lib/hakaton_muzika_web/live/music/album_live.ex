defmodule HakatonMuzikaWeb.Music.AlbumLive do
  alias HakatonMuzika.Music
  require Logger
  use HakatonMuzikaWeb, :live_view

  def mount(%{"id" => id}, session, socket) do
    current_user = HakatonMuzika.Accounts.get_user_by_session_token(session["user_token"])
    album = Music.get_album_with_songs!(id)
    {:ok, 
      socket
      |> assign_album(album)
      |> assign(:user, current_user)
    } 
  end

  def assign_album(socket, album) do
    assign_new(socket, :album, fn -> album end)
  end

  def handle_event("play", %{"song_id" => id}, socket) do
    song = Music.get_song!(id)
    #BluetoothAmpWeb.PlayerState.play(song)
    {:noreply, socket}
  end

  def handle_event("add-to-playlist", %{"song_id" => id}, socket) do
    HakatonMuzika.Playlists.add_song(HakatonMuzika.Playlists.get_user_playlists(socket.assigns.user) |> hd(), HakatonMuzika.Music.get_song!(id))
    {:noreply, socket}
  end

  def song_card(%{id: _, title: _, duration: _, track: _, album_name: _, album_cover: _} = assigns) do
~H"""
    <div phx-value-song_id={@id} class="flex justify-between m-0 p-3 rounded-xl hover:bg-neutral-900">
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
      <div phx-click="add-to-playlist" phx-value-song_id={@id} >
        <FontAwesome.LiveView.icon name="plus" type="solid" class="w-6 h-6 fill-white"/>
      </div>
    </div>
    """
  end

  defp duration_str(duration) do
    duration_s = floor(duration / 1000)
    mins = floor(duration_s / 60)
    seconds = 
      rem(duration_s, 60)
      |> pad()
    "#{mins}:#{seconds}"
  end

  defp pad(x) do
    x
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

end
