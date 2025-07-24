defmodule Raffley.Raffle do
  defstruct [:id, :prize, :ticket_price, :status, :image_path, :description]
end

defmodule Raffley.Raffles do
  def list_raffles do
    [
      %Raffley.Raffle{
        id: 1
      }
    ]
  end
end
