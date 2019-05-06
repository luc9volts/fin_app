defmodule AccountTest do
  import Commanded.Assertions.EventAssertions
  import Commanded.Assertions.EventAssertions

  use ExUnit.Case
  doctest Account

  test "Ensure sufficient funds when withdrawing" do
    :ok =
      AccountRouter.dispatch(%CreateAccount{
        account_number: "12"
      })

    assert_receive_event(
      AccountCreated,
      fn event -> event.account_number == "12" end,
      fn event -> assert event.balance == 1000 end
    )

    {:error, msg} =
      AccountRouter.dispatch(%WithdrawFunds{
        transfer_id: UUID.uuid4(),
        account_number: "12",
        amount: 10001
      })

    assert msg == "Insufficient funds: account_number: 12, balance: 1000"
  end

  test "Ensure email is sent" do
    :ok =
      AccountRouter.dispatch(%CreateAccount{
        account_number: "42"
      })

    assert_receive_event(
      AccountCreated,
      fn event -> event.account_number == "42" end,
      fn event -> assert event.balance == 1000 end
    )

    :ok =
      AccountRouter.dispatch(%WithdrawFunds{
        transfer_id: UUID.uuid4(),
        account_number: "42",
        amount: 900
      })

    assert_correlated(
      FundsWithdrawn,
      fn e -> e.account_number == "42" end,
      EmailSent,
      fn e -> e.account_number == "42" end
    )
  end

  test "Ensure sufficient funds when sending money" do
    :ok =
      AccountRouter.dispatch(%CreateAccount{
        account_number: "18"
      })

    assert_receive_event(
      AccountCreated,
      fn event -> event.account_number == "18" end,
      fn event -> assert event.balance == 1000 end
    )

    {:error, msg} =
      AccountRouter.dispatch(%SendFunds{
        transfer_id: UUID.uuid4(),
        account_number: "18",
        credit_account: "42",
        amount: 10001
      })

    assert msg == "Insufficient funds: account_number: 18, balance: 1000"
  end

  test "Ensure sufficient funds when withdraw" do
    :ok =
      AccountRouter.dispatch(%CreateAccount{
        account_number: "19"
      })

    assert_receive_event(
      AccountCreated,
      fn event -> event.account_number == "19" end,
      fn event -> assert event.balance == 1000 end
    )

    {:error, msg} =
      AccountRouter.dispatch(%WithdrawFunds{
        transfer_id: UUID.uuid4(),
        account_number: "19",
        amount: 10001
      })

    assert msg == "Insufficient funds: account_number: 19, balance: 1000"
  end
end
