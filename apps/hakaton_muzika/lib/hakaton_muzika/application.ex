defmodule HakatonMuzika.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HakatonMuzika.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: HakatonMuzika.PubSub}
      # Start a worker by calling: HakatonMuzika.Worker.start_link(arg)
      # {HakatonMuzika.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: HakatonMuzika.Supervisor)
  end
end
