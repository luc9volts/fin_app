defmodule FundsSent do
  @derive Jason.Encoder
  defstruct transfer_id: nil,
            credit_account: nil,
            amount: 0
end
