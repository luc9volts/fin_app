defmodule AccountRouter do
  use Commanded.Commands.Router

  identify(Account, by: :account_number)
  dispatch([CreateAccount, SendFunds, ReceiveFunds], to: Account)
end
