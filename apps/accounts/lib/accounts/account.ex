defmodule Account do
  defstruct account_number: nil,
            balance: 0,
            notified_about_withdraw: nil

  # Execute commands
  def execute(%Account{account_number: nil}, %CreateAccount{} = create_account) do
    %AccountCreated{
      account_number: create_account.account_number,
      balance: create_account.initial_balance
    }
  end

  def execute(%Account{}, %CreateAccount{}), do: {:error, :account_already_created}

  def execute(%Account{balance: balance, account_number: number}, %SendFunds{amount: amount})
      when amount > balance,
      do: {:error, "Insufficient funds: account_number: #{number}, balance: #{balance}"}

  def execute(_, %SendFunds{} = cmd) do
    %FundsSent{
      transfer_id: cmd.transfer_id,
      credit_account: cmd.credit_account,
      amount: cmd.amount
    }
  end

  def execute(_, %ReceiveFunds{} = cmd) do
    %FundsReceived{
      transfer_id: cmd.transfer_id,
      debit_account: cmd.account_number,
      amount: cmd.amount
    }
  end

  def execute(%Account{balance: balance, account_number: number}, %WithdrawFunds{amount: amount})
      when amount > balance,
      do: {:error, "Insufficient funds: account_number: #{number}, balance: #{balance}"}

  def execute(_, %WithdrawFunds{} = cmd) do
    %FundsWithdrawn{
      transfer_id: cmd.transfer_id,
      account_number: cmd.account_number,
      amount: cmd.amount
    }
  end

  def execute(_, %SendEmail{} = cmd) do
    %EmailSent{
      transfer_id: cmd.transfer_id,
      account_number: cmd.account_number,
      amount: cmd.amount
    }
  end

  # Changing state of the Account
  def apply(%Account{} = account, %AccountCreated{} = created_account) do
    %Account{
      account
      | account_number: created_account.account_number,
        balance: created_account.balance
    }
  end

  def apply(%Account{} = account, %FundsSent{} = event) do
    %Account{
      account
      | balance: account.balance - event.amount
    }
  end

  def apply(%Account{} = account, %FundsReceived{} = event) do
    %Account{
      account
      | balance: account.balance + event.amount
    }
  end

  def apply(%Account{} = account, %FundsWithdrawn{} = event) do
    %Account{
      account
      | balance: account.balance - event.amount
    }
  end

  def apply(%Account{} = account, %EmailSent{}) do
    %Account{
      account
      | notified_about_withdraw: true
    }
  end
end
