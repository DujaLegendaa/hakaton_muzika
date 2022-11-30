defmodule HakatonMuzikaWeb.PlayerState do
  use GenServer
  alias HakatonMuzika.Music

  @name __MODULE__
  @topic "player_state"
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    HakatonMuzikaWeb.Endpoint.subscribe(@topic)
    :ets.new(:player_state, [:set, :named_table])
    :ets.insert(:player_state, {:current_song, nil})
    {:ok, :ok}
  end

  def add_current_song(song) do
    GenServer.cast(@name, {:insert, {:current_song, song}})
    HakatonMuzikaWeb.Endpoint.broadcast(@topic, "current_song", song)
  end

  def get_current_song() do
    [{:current_song, song}] = :ets.lookup(:player_state, :current_song)
    song
  end

  def remove_current_song() do
    GenServer.cast(@name, {:insert, {:current_song, nil}})
    HakatonMuzikaWeb.Endpoint.broadcast(@topic, "current_song", nil)
  end

  def handle_cast({:insert, data}, _state) do
    :ets.insert(:player_state, data)
    {:noreply, :ok}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

    
end
