defmodule HakatonMuzikaWeb.PlaylistLive do
  use HakatonMuzikaWeb, :live_view

  alias HakatonMuzika.Playlists
  def mount(%{"id" => id}, session, socket) do
    playlist = Playlists.get_playlist_preloaded!(id)
    {:ok, socket
      |> assign_playlist(playlist)
    }
  end

  def assign_playlist(socket, playlist) do
    assign_new(socket, :playlist, fn -> playlist end)
  end

  # TODO OPTIMZE
  def song_card(%{id: _, title: _, duration: _, track: _, cover: _, album_name: _, artist_name: _} = assigns) do
~H"""
    <div class="flex px-10 py-2 gap-x-2">
      <img class="w-[50px] lg:w-[80px]" src={HakatonMuzikaWeb.B3.get_url @cover} />
      <div class="grid grid-cols-3 items-center w-full">
      <div>
        <p class="text-sm lg:text-md"> <%= cut_text @title %> </p>
        <p class="text-xs lg:text-sm"> <%= cut_text @artist_name %></p>
      </div>
      <p class="justify-self-center text-sm lg:text-md font-bold"> <%= cut_text @album_name %></p>
      <p class="justify-self-end text-xs lg:text-sm"> <%= duration_str @duration %> </p>
      </div>
    </div>
    """
  end

"""
  
    <div class="relative">
      <div class="flex justify-between m-0 p-3 rounded-xl hover:bg-neutral-900">
        <div class="flex gap-x-[1rem]">
          <img class="rounded-2xl w-[60px] lg:w-[75px]" src={HakatonMuzikaWeb.B3.get_url(HakatonMuzika.Music.get_cover(@id))} />
          <div class="flex flex-col justify-evenly">
            <p class="text-xl font-bold"><%= cut_text @title %></p>
            <p class="text-sm"><%= cut_text HakatonMuzika.Music.get_album_name(@id) %></p>
            <div class="flex items-center">
              <FontAwesome.LiveView.icon name="guitar" type="solid" class="w-4 h-4 fill-slate-400"/>
              <p class="text-xs text-slate-400 font-semibold "><%= duration_str(@duration) %></p>
            </div>
          </div>
        </div>
      </div>
    </div>
  """
end
