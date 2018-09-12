defmodule Ds18Temp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.Project.config()[:target]

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ds18Temp.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children("host") do
    [
      # Starts a worker by calling: Ds18Temp.Worker.start_link(arg)
      # {Ds18Temp.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Starts a worker by calling: Ds18Temp.Worker.start_link(arg)
      # {Ds18Temp.Worker, arg},
    ]
  end
end
