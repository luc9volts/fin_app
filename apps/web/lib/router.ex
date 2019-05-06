defmodule FinAppRouter do
  use Plug.Router

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  post "/create" do
    {status, body} =
      case conn.body_params do
        %{"account_number" => account_number} ->
          {200, create_account(account_number)}

        _ ->
          {422, "erro"}
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
          {200, transf_account(debit_account, credit_account, amount)}

        _ ->
          {422, "erro"}
      end

    send_resp(conn, status, Poison.encode!(body))
  end

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

  match(_, do: send_resp(conn, 404, "oops"))
end
