defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  @doc """
  라이브뷰 프로세스를 초기화 하는 함수
  Controller의connection(conn) 구조체처럼 socket 구조체를 사용한다.
  """
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :tick, 2000)
    end

    socket = assign(socket, tickets: 0, price: 3, page_title: "Estimator")

    IO.inspect(self(), label: "MOUNT")

    # {:ok, socket, layout: {RaffleyWeb.Layouts, :simple}}
    {:ok, socket}
  end

  # render 함수를 지우고 estimator_live.html.heex 파일을 만들어서 거기 heex 템플릿을 넣어도 됨
  # 피닉스는 live_view 모듈에서 render 함수가 없으면 이름이 동일한 heex파일을 찾아서 render 함수로 만들어줌(컴파일 시점에)
  # phx-value-XXX 는 이벤트 함수에 %{"XXX" => "value"} 같은 맵으로 전달한다.
  def render(assigns) do
    IO.inspect(self(), label: "RENDER")

    ~H"""
    <div class="estimator">
      <h1>Raffle Esimator</h1>
      <section>
        <button phx-click="add" phx-value-quantity="5">
          +
        </button>
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

      <form phx-submit="set-price">
        <label>Ticket Price:</label>
        <input type="number" , name="price" value={@price} />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    IO.inspect(self(), label: "ADD")

    socket = update(socket, :tickets, &(&1 + String.to_integer(quantity)))

    {:noreply, socket}
  end

  # 브라우저(클라이언트) 에서 보낸 이벤트는 handle_event/3 함수로 받는다.
  def handle_event("set-price", %{"price" => price}, socket) do
    socket = assign(socket, :price, String.to_integer(price))
    {:noreply, socket}
  end

  # 프로세스가 보낸 메시지는 handle_info/2 함수로 받는다.
  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 2000)
    {:noreply, update(socket, :tickets, &(&1 + 10))}
  end
end
