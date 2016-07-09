defmodule EctoTest.Types.Json do
  @behaviour Ecto.Type

  def type, do: :json

  def load({:ok, json}), do: {:ok, json}
  def load(value), do: load(Poison.decode(value))

  def dump(value), do: Poison.encode(value)
end
