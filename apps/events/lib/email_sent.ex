defmodule EmailSent do
  @derive Jason.Encoder
  defstruct transfer_id: nil,
            account_number: nil,
            amount: 0,
            email_address: nil,
            subject: nil,
            body: nil
end
