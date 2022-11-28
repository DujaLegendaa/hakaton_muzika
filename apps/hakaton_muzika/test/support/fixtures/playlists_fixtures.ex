defmodule HakatonMuzika.PlaylistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HakatonMuzika.Playlists` context.
  """

  @doc """
  Generate a playlist.
  """
  def playlist_fixture(attrs \\ %{}) do
    {:ok, playlist} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> HakatonMuzika.Playlists.create_playlist()

    playlist
  end
end
