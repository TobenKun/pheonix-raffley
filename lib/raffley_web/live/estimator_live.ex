defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, tickets: 0, price: 3)

    IO.inspect(socket)

    {:ok, socket}
  end

  # render 함수를 지우고 estimator_live.html.heex 파일을 만들어서 거기 heex 템플릿을 넣어도 됨
  # 피닉스는 live_view 모듈에서 render 함수가 없으면 이름이 동일한 heex파일을 찾아서 render 함수로 만들어줌(컴파일 시점에)
  def render(assigns) do
    ~H"""
    <div class="estimator">
      <h1>Raffle Esimator</h1>
      <section>
        <div>
          {@tickets}
        </div>
        <div>
          @
        </div>
        <div>
          ${@price}
        </div>
        <div>
          =
        </div>
        <div>
          ${@tickets * @price}
        </div>
      </section>
    </div>
    """
  end

  # handle_event
end
