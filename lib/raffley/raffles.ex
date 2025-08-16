defmodule Raffley.Raffles do
  alias Raffley.Raffles.Raffle
  alias Raffley.Repo
  import Ecto.Query

  def list_raffles do
    Repo.all(Raffle)
  end

  def filter_raffles(filter) do
    Raffle
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> sort(filter["sort_by"])
    |> Repo.all()
  end

  defp with_status(query, status)
       when status in ~W(open closed upcoming) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [r], ilike(r.prize, ^"%#{q}%"))
  end

  # 굳이 함수 여러개로 쪼개지 말고 문자열 들어온거를 String.to_atom/1 쓰면 되지 않나 생각한 당신!
  # 절대 좋은 방법이 아니라고 한다.
  # 한 엘릭서 앱에서 사용 가능 한 아톰의 숫자는 1,048,576로 정해져있다.
  # 나이브하게 입력값을 그대로 아톰으로 만들면 언젠가 빠갈남
  #
  # 또는 String.to_existing_atom/1 을 쓰면 기존에 없는 아톰을 생성하려고 할 때 예외를 발생시킨다.
  # 강의 26강 note 참고!

  defp sort(query, "prize") do
    order_by(query, :prize)
  end

  defp sort(query, "ticket_price_desc") do
    order_by(query, desc: :ticket_price)
  end

  defp sort(query, "ticket_price_asc") do
    order_by(query, asc: :ticket_price)
  end

  defp sort(query, _) do
    order_by(query, :id)
  end

  def get_raffle!(id) do
    Repo.get!(Raffle, id)
  end

  def featured_raffles(raffle) do
    Process.sleep(2000)

    Raffle
    |> where(status: :open)
    |> where([r], r.id != ^raffle.id)
    |> order_by(desc: :ticket_price)
    |> limit(3)
    |> Repo.all()
  end
end
