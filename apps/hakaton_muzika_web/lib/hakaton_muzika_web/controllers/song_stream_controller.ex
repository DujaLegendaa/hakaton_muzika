defmodule HakatonMuzikaWeb.SongStreamController do
  use HakatonMuzikaWeb, :controller

  def index(conn, %{"id" => id}) do
    case HakatonMuzika.Music.get_song(id) do
      %HakatonMuzika.Music.Song{path: path} -> 
        Plug.Conn.send_file(conn, 200, path)
      nil -> 
        Plug.Conn.send_resp(conn, 404, "file not found")
    end
  end
  
end
