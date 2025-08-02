defmodule RaffleyWeb.CustomComponents do
  # raffley_web.ex의 html_helper 함수에 이 파일을 추가하면
  # 매번 이 모듈을 임포트 하지 않아도 된다.
  use RaffleyWeb, :html

  attr :status, :atom, required: true, values: [:upcoming, :open, :closed]
  attr :class, :string, default: nil
  attr :rest, :global

  def badge(assigns) do
    ~H"""
    <div
      class={[
        "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
        @status == :open && "text-lime-600 border-lime-600",
        @status == :upcoming && "text-amber-600 border-amber-600",
        @status == :closed && "text-gray-600 border-gray-600",
        @class
      ]}
      {@rest}
    >
      {@status}
    </div>
    """
  end

  slot :inner_block, required: true
  slot :details

  def banner(assigns) do
    assigns = assign(assigns, :emoji, ~W(😜 😂 😢 😎) |> Enum.random())

    ~H"""
    <div class="banner">
      <h1>
        {render_slot(@inner_block)}
      </h1>
      <div :for={details <- @details} class="details">
        {render_slot(details, @emoji)}
      </div>
    </div>
    """
  end
end
