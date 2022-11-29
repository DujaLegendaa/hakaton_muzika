defmodule HakatonMuzikaWeb.UserRegistrationController do
  use HakatonMuzikaWeb, :controller

  alias HakatonMuzika.Accounts
  alias HakatonMuzika.Accounts.User
  alias HakatonMuzikaWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          HakatonMuzika.Playlists.create_playlist(user, %{name: "#{user.username}'s playlist"})
        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
