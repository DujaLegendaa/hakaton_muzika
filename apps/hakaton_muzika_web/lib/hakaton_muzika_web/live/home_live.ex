defmodule HakatonMuzikaWeb.HomeLive do
  use HakatonMuzikaWeb, :live_view
  def mount(_, _, socket) do
    {:ok, assign_new(socket, :albums, fn -> HakatonMuzika.Music.list_albums(5) end)}
  end

end
