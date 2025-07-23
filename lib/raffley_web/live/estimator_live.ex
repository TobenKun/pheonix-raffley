defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, tickets: 0, price: 3)

    IO.inspect(socket)

    {:ok, socket}
  end

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
