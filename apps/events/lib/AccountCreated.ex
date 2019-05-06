defmodule AccountCreated do
  @derive Jason.Encoder
  defstruct account_number: nil,
            balance: nil
end
