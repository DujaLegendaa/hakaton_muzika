defmodule HakatonMuzikaWeb.PageController do
  use HakatonMuzikaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
