defmodule Account do
  defstruct account_number: nil,
            balance: nil

  # Execute commands
  def execute(%Account{account_number: nil}, %CreateAccount{} = create_account) do
    %AccountCreated{
      account_number: create_account.account_number,
      balance: create_account.initial_balance
    }
  end

  def execute(%Account{}, %CreateAccount{}), do: {:error, :account_already_created}

  # Changing state of the Account
  def apply(%Account{} = account, %AccountCreated{} = created_account) do
    %Account{
      account
      | account_number: created_account.account_number,
        balance: created_account.balance
    }
  end

  # def apply(%Account{} = account, %ChallengeStarted{}) do
  #   %Account{account | balance: :active}
  # end
end
