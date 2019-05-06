defmodule Accounts.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      TransferFundsProcessManager
    ]

    opts = [strategy: :one_for_one, name: Accounts.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
