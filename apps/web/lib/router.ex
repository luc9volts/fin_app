defmodule FinAppRouter do
  use Plug.Router

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  post "/create" do
    send_resp(conn, 200, Poison.encode!(%{response: create_account()}))
  end

  defp create_account() do
    %CreateAccount{
      account_number: UUID.uuid4()
    }
    |> AccountRouter.dispatch()
  end

  match(_, do: send_resp(conn, 404, "oops"))
end
