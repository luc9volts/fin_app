defmodule TransferFundsProcessManager do
  use Commanded.ProcessManagers.ProcessManager,
    name: "TransferFundsProcessManager",
    router: AccountRouter

  @derive Jason.Encoder
  defstruct []

  def interested?(%FundsSent{transfer_id: transfer_id}), do: {:start, transfer_id}
  def interested?(%FundsReceived{transfer_id: transfer_id}), do: {:stop, transfer_id}

  def handle(_, %FundsSent{} = event) do
    %ReceiveFunds{
      transfer_id: event.transfer_id,
      account_number: event.credit_account,
      amount: event.amount
    }
  end
end
