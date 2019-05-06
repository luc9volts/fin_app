defmodule FundsReceived do
  @derive Jason.Encoder
  defstruct transfer_id: nil,
            debit_account: nil,
            amount: 0
end
