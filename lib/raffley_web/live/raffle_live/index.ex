defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  import RaffleyWeb.CustomComponents

  def mount(_params, _session, socket) do
    # IO.inspect(socket.assigns.streams.raffles, label: "MOUNT")
    #
    # socket =
    #   attach_hook(socket, :log_stream, :after_render, fn
    #     socket ->
    #       IO.inspect(socket.assigns.streams.raffles, label: "AFTER RENDER")
    #       socket
    #   end)

    {:ok, socket}
  end

  # url 파라미터에 기반해 변하는 것들만 여기서 assign 할것
  # 변하지 않는 상태도 여기에 두면 patch 할 때마다 호출됨 -> mount 콜백으로

  # push_patch 나 patch를 쓰는 경우 필연적으로 def handle_params 함수를 쓸 수 밖에 없다.
  # 이 때는 mount가 호출되지 않기 때문에 LiveView state를 갱신하기 위해서는 이 함수가 필요하다.
  # 패치나 푸시 패치를 사용하지 않으면 마운트만 써도 무방

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> stream(:raffles, Raffles.filter_raffles(params), reset: true)
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <.banner :if={false}>
        <.icon name="hero-sparkles-solid" /> Mystery Raffle Coming Soon!
        <:details :let={vibe}>
          To Be Revealed Tomorrow {vibe}
        </:details>
        <:details>
          Any quesses?
        </:details>
      </.banner>

      <.filter_form form={@form} />

      <div class="raffles" id="raffles" phx-update="stream">
        <div id="empty" class="no-results only:block hidden">
          No raffles found. Try changing your filters.
        </div>
        <.raffle_card :for={{dom_id, raffle} <- @streams.raffles} raffle={raffle} id={dom_id} />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" phx-debounce="300" />

      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={[:upcoming, :open, :closed]}
      />

      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Sort By"
        options={[
          Prize: "prize",
          "Price: High to Low": "ticket_price_desc",
          "Price: Low to High": "ticket_price_asc"
        ]}
      />
      <.link patch={~p"/raffles"}>
        Reset
      </.link>
    </.form>
    """
  end

  attr :raffle, Raffley.Raffles.Raffle, required: true
  attr :id, :string, required: true

  def raffle_card(assigns) do
    # <.link href={~p"/raffles/#{@raffle.id}"}>
    # https://chatgpt.com/s/t_68903dfe5f808191bffce4da83e8fdec 참고
    ~H"""
    <.link navigate={~p"/raffles/#{@raffle}"} id={@id}>
      <div class="card">
        <img src={@raffle.image_path} />
        <h2>{@raffle.prize}</h2>
        <div class="details">
          <div class="price">
            ${@raffle.ticket_price} / ticket
          </div>
          <.badge status={@raffle.status} />
        </div>
      </div>
    </.link>
    """
  end

  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by))
      |> Map.reject(fn {_, v} -> v == "" end)

    # push_patch 가 더 효율적일 수도 있다고 함
    # patch를 쓸 때는 스트림 리셋하기
    socket = push_patch(socket, to: ~p"/raffles?#{params}")

    {:noreply, socket}
  end
end
