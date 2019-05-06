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

  defp create_account() do
    %CreateAccount{
      account_number: UUID.uuid4()
    }
    |> AccountRouter.dispatch()
  end

  match(_, do: send_resp(conn, 404, "oops"))
end
