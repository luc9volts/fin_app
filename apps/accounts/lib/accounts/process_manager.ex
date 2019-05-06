# defmodule TransferFundsProcessManager do
#   use Commanded.ProcessManagers.ProcessManager,
#     name: "TransferFundsProcessManager",
#     router: AccountRouter

#   @derive Jason.Encoder
#   defstruct [
#     :transfer_uuid,
#     :debit_account,
#     :credit_account,
#     :amount,
#     :status
#   ]

#   def interested?(%FundsTransferRequested{transfer_uuid: transfer_uuid}),
#     do: {:start, transfer_uuid}

#   def interested?(%FundsWithdrawn{transfer_uuid: transfer_uuid}), do: {:continue, transfer_uuid}
#   def interested?(%FundsDeposited{transfer_uuid: transfer_uuid}), do: {:stop, transfer_uuid}
#   def interested?(_event), do: false

#   # Command dispatch

#   def handle(%TransferFundsProcessManager{}, %FundsTransferRequested{} = event) do
#     %FundsTransferRequested{
#       transfer_uuid: transfer_uuid,
#       debit_account: debit_account,
#       amount: amount
#     } = event

#     %WithdrawFunds{account_number: debit_account, transfer_uuid: transfer_uuid, amount: amount}
#   end

#   def handle(%TransferFundsProcessManager{} = pm, %FundsWithdrawn{}) do
#     %TransferFundsProcessManager{
#       transfer_uuid: transfer_uuid,
#       credit_account: credit_account,
#       amount: amount
#     } = pm

#     %DepositFunds{account_number: credit_account, transfer_uuid: transfer_uuid, amount: amount}
#   end

#   # State mutators

#   def apply(%TransferFundsProcessManager{} = transfer, %FundsTransferRequested{} = event) do
#     %FundsTransferRequested{
#       transfer_uuid: transfer_uuid,
#       debit_account: debit_account,
#       credit_account: credit_account,
#       amount: amount
#     } = event

#     %TransferFundsProcessManager{
#       transfer
#       | transfer_uuid: transfer_uuid,
#         debit_account: debit_account,
#         credit_account: credit_account,
#         amount: amount,
#         status: :withdraw_Funds_from_debit_account
#     }
#   end

#   def apply(%TransferFundsProcessManager{} = transfer, %FundsWithdrawn{}) do
#     %TransferFundsProcessManager{transfer | status: :deposit_Funds_in_credit_account}
#   end
# end
