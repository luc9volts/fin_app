defmodule FinAppRouter do
  use Plug.Router

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  post "/create" do
    {status, body} =
      case conn.body_params do
        %{"account_number" => account_number} -> format_return(create_account(account_number))
        _ -> {400, :bad_request}
      end

    send_resp(conn, status, Poison.encode!(body))
  end

  post "/transf" do
    {status, body} =
      case conn.body_params do
        %{
          "debit_account" => debit_account,
          "credit_account" => credit_account,
          "amount" => amount
        } ->
          format_return(transf_account(debit_account, credit_account, amount))

        _ ->
          {400, :bad_request}
      end

    send_resp(conn, status, Poison.encode!(body))
  end

  post "/withdraw" do
    {status, body} =
      case conn.body_params do
        %{
          "account_number" => account_number,
          "amount" => amount
        } ->
          format_return(withdraw(account_number, amount))

        _ ->
          {400, :bad_request}
      end

    send_resp(conn, status, Poison.encode!(body))
  end

  match(_, do: send_resp(conn, 404, "oops"))

  defp create_account(account_number) do
    %CreateAccount{
      account_number: account_number
    }
    |> AccountRouter.dispatch()
  end

  defp transf_account(debit_account, credit_account, amount) do
    %SendFunds{
      transfer_id: UUID.uuid4(),
      account_number: debit_account,
      credit_account: credit_account,
      amount: amount
    }
    |> AccountRouter.dispatch()
  end

  defp withdraw(account_number, amount) do
    %WithdrawFunds{
      transfer_id: UUID.uuid4(),
      account_number: account_number,
      amount: amount
    }
    |> AccountRouter.dispatch()
  end

  defp format_return(:ok) do
    {200, "success"}
  end

  defp format_return({:error, msg}) do
    {422, msg}
  end
end
