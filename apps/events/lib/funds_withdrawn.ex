defmodule FundsWithdrawn do
  @derive Jason.Encoder
  defstruct transfer_id: nil,
            account_number: nil,
            amount: 0
end
