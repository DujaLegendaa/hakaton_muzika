defmodule HakatonMuzikaWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  alias Phoenix.LiveView.JS

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

  def assign_playlists(socket, session) do
    assign_new(socket, :user_playlists, 
      fn -> 
        case Map.fetch(session, "user_token") do
          {:ok, token} ->
            token
              |> HakatonMuzika.Accounts.get_user_by_session_token()
              |> HakatonMuzika.Playlists.get_user_playlists()
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
