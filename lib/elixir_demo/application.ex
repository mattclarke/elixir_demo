defmodule ElixirDemo.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :observer.start()
    children = [
      {ElixirDemo.Registry, []},
      {ElixirDemo.ReceiverSupervisor, []},
      {ElixirDemo.Sender, []}
    ]

    opts = [strategy: :one_for_one, name: ElixirDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
