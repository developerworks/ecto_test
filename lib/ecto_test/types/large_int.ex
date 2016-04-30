defmodule EctoTest.Types.LargeInt do
  @behaviour Ecto.Type
  def type, do: :string
  def cast(string) when is_binary(string) do
    {:ok, string}
  end
  def cast(integer) when is_integer(integer) do
    {:ok, :erlang.integer_to_binary(integer)}
  end
  def load(string), do: {:ok, string |> String.strip |> String.to_integer()}
  def dump(integer) when is_integer(integer), do: {:ok, Integer.to_string(integer)}
  def dump(_), do: :error
end
