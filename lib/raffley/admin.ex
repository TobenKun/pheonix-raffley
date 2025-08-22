defmodule Raffley.Admin do
  alias Raffley.Raffles.Raffle
  alias Raffley.Repo
  import Ecto.Query

  def list_raffles do
    Raffle
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  # FIX: 이렇게도 작동은 하지만, 아주 위험한 방법이다.
  # 유저의 입력을 받는 부분은 충분히 검증해야함
  # ex) 이름 없는 -3달러 짜리 raffle도 등록이 됨
  def create_raffle(attrs \\ %{}) do
    %Raffle{}
    |> Raffle.changeset(attrs)
    |> Repo.insert()
  end
end
