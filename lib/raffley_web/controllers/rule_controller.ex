defmodule RaffleyWeb.RuleController do
  use RaffleyWeb, :controller

  alias Raffley.Rules

  def index(conn, _params) do
    emojis = ~W(😁 😅 🥸 🎃 💩 😴) |> Enum.random() |> String.duplicate(5)

    # 컨트롤러는 룰이 어떻게 구성되어야 하는지는 몰라도 됨
    # 컨트롤러와 데이터 소스를 분리하는 것
    rules = Rules.list_rules()

    # assings the key-value to the conn
    render(conn, :index, emojis: emojis, rules: rules)
  end
end
