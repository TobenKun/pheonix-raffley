defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :raffles, Raffles.list_raffles())
    {:ok, socket}
  end
end
