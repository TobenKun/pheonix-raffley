defmodule Raffley.Raffles.Raffle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "raffles" do
    field :status, Ecto.Enum, values: [:upcoming, :open, :closed], default: :upcoming
    field :description, :string
    field :prize, :string
    field :ticket_price, :integer, default: 1
    field :image_path, :string, default: "/images/placeholder.jpg"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(raffle, attrs) do
    raffle
    |> cast(attrs, [:prize, :description, :ticket_price, :status, :image_path])
    |> validate_required([:prize, :description, :ticket_price, :status, :image_path])
    |> validate_length(:description, min: 10)
    |> validate_number(:ticket_price, greater_than_or_equal_to: 1)
  end

  # 필요에 따라 다른 changeset 함수도 만들 수 있음
  # ex) admin은 특정 데이터가 빠진 더미 데이터를 만들 수 있는 등
end
