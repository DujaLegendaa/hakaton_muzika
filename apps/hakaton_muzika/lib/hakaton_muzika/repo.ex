defmodule HakatonMuzika.Repo do
  use Ecto.Repo,
    otp_app: :hakaton_muzika,
    adapter: Ecto.Adapters.SQLite3
end
