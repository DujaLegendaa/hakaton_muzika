defmodule HakatonMuzikaWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      HakatonMuzikaWeb.Telemetry,
      # Start the Endpoint (http/https)
      HakatonMuzikaWeb.Endpoint,
      # Start a worker by calling: HakatonMuzikaWeb.Worker.start_link(arg)
      # {HakatonMuzikaWeb.Worker, arg}
      HakatonMuzikaWeb.PlayerState
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HakatonMuzikaWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HakatonMuzikaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
