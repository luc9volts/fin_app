defmodule FinAppRouter do
  use Plug.Router

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  post "/create" do
    {status, body} =
      case create_account() do
        :ok -> {200, "account created"}
        _ -> {422, "error"}
      end

    send_resp(conn, status, body)
  end

  post "/transf" do
    {status, body} =
      case conn.body_params do
        %{"debit_account" => debit_account,
         "credit_account" => credit_account} -> {200, transf_account(debit_account, credit_account)}
        _ -> {422, "erro"}
      end

    send_resp(conn, status, body)
  end

  # post "/transf" do
  #   {status, body} =
  #     case transf_account() do
  #       {:ok, _} -> {200, "transfered"}
  #       {:error, result} -> {422, result}
  #       _ -> {500, "erro"}
  #     end

  #   send_resp(conn, status, body)
  # end

  defp create_account() do
    %CreateAccount{
      account_number: "me2"
    }
    |> AccountRouter.dispatch()
  end

  defp transf_account(debit_account, credit_account) do
    %SendFunds{
      transfer_id: UUID.uuid4(),
      account_number: debit_account,
      credit_account: credit_account,
      amount: 10
    }
    |> AccountRouter.dispatch()
  end

  match(_, do: send_resp(conn, 404, "oops"))
end
