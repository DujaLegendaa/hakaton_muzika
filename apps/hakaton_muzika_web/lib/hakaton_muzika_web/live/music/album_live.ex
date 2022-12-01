defmodule HakatonMuzikaWeb.Music.AlbumLive do
  alias HakatonMuzika.Music
  alias Phoenix.LiveView.JS
  require Logger
  use HakatonMuzikaWeb, :live_view

  def mount(%{"id" => id}, session, socket) do
    user_playlists = 
    album = Music.get_album_with_songs!(id)
    {:ok,
      socket
      |> assign_album(album)
      |> assign_new(:user_playlists, &assign_playlists(&1, session))
    }
  end

  def assign_playlists(socket, session) do
    case Map.fetch(session, "user_token") do
      {:ok, token} ->
        token
          |> HakatonMuzika.Accounts.get_user_by_session_token()
          |> HakatonMuzika.Playlists.get_user_playlists()
      :error ->
        nil
    end
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

  def song_card(%{id: _, title: _, duration: _, track: _, cover: _, album_name: _, playlists: _} = assigns) do
~H"""
    <div class="relative">
      <div phx-click="play" phx-value-song_id={@id} class="flex px-10 py-2 gap-x-2">
        <img class="w-[50px] lg:w-[80px]" src={HakatonMuzikaWeb.B3.get_url @cover} />
        <div class="grid grid-cols-3 items-center w-full">
        <div>
          <p class="text-sm lg:text-md"> <%= cut_text @title %> </p>
        </div>
          <p class="justify-self-center text-sm lg:text-md font-bold"> <%= cut_text @album_name %></p>
        </div>
        <%= if @playlists do %>
          <div class="hover:cursor-pointer" phx-click={JS.toggle(to: "#menu-#{Integer.to_string(@id)}", in: {"ease-in duration-150", "opacity-0", "opacity-100"}, out: "fade-out-scale")} >
            <FontAwesome.LiveView.icon name="plus" type="solid" class="w-6 h-6 fill-white"/>
          </div>
        <% end %>
      </div>
      <.playlist_menu id={@id} playlists={@playlists} />
    </div>
    """
  end

  def playlist_menu(%{id: _, playlists: _} = assigns) do
~H"""
    <%= if @playlists do %>
      <div class="hidden z-10 absolute top-9 right-10 p-2 rounded-xl bg-[#60A348] w-[10%]" id={"menu-#{Integer.to_string(@id)}"}>
        <%= for playlist <- @playlists do %>
          <p class="hover:cursor-pointer font-bold" phx-click="add-to-playlist" phx-value-playlist_id={playlist.id} phx-value-song_id={@id}> <%= playlist.name %> </p>
        <% end %>
      </div>
    <% end %>
    """
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
