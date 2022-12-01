defmodule HakatonMuzikaWeb.Playlist.ListLive do
  use HakatonMuzikaWeb, :live_view
  alias HakatonMuzika.Playlists

  def mount(params, session, socket) do
    {:ok, 
      socket
      |> assign_new(:playlist_changeset, fn -> Playlists.change_playlist(%Playlists.Playlist{}) end)
      |> assign_current_user(session)
    }
  end

  def handle_event("save", %{"playlist" => params}, socket) do
    case Playlists.create_playlist(socket.assigns.current_user, params) do
      {:ok, playlist} -> 
        {:noreply, 
          socket
          |> put_flash(:info, "Successfully created playlist #{playlist.name}")
        }
    end
  end
  
end
