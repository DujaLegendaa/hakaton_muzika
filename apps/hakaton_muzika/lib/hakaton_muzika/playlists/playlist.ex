defmodule HakatonMuzika.Playlists.Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "playlists" do
    field :name, :string
    belongs_to :user, HakatonMuzika.Accounts.User
    many_to_many :songs, HakatonMuzika.Music.Song, join_through: "playlists_songs", on_replace: :delete, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
