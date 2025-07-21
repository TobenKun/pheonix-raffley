defmodule RaffleyWeb.RuleController do
  use RaffleyWeb, :controller

  def index(conn, _params) do
    emojis = ~W(😁 😅 🥸 🎃 💩 😴) |> Enum.random() |> String.duplicate(5)

    # 컨트롤러는 룰이 어떻게 구성되어야 하는지는 몰라도 됨
    rules = Rules.list_rules()

    # assings the key-value to the conn
    render(conn, :index, emojis: emojis)
  end
end
