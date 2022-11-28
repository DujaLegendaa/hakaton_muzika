defmodule HakatonMuzika.Repo.Migrations.CreatePlaylists do
  use Ecto.Migration

  def change do
    create table(:playlists) do
      add :name, :string
      add :creator, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:playlists, [:creator])
  end
end
