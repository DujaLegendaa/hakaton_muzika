defmodule HakatonMuzika.Repo.Migrations.CreatePlaylists do
  use Ecto.Migration

  def change do
    create table(:playlists) do
      add :name, :string
      add :user_id, references(:users)

      timestamps()
    end

    create index(:playlists, [:user_id])
  end
end
