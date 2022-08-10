defmodule TransactApp.Orders.LineItem do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :price, :decimal, default: 0.0
    field :locked, :boolean, default: false
  end

  @doc false
  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, [:name, :price])
    |> validate_required([:name, :price])
  end

  def lock_changeset(line_item) do
    line_item
    |> change(%{locked: true})
  end
end
