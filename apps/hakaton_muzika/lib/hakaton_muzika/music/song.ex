defmodule HakatonMuzika.Music.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :name, :string
    field :track, :integer
    field :duration, :integer
    field :path, :string
    belongs_to :album, HakatonMuzika.Music.Album
    many_to_many :playlists, HakatonMuzika.Playlists.Playlist, join_through: "playlists_songs"

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:name, :track, :duration, :path])
    |> validate_required([:name, :track, :duration, :path])
  end
end
