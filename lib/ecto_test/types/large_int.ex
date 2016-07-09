require Logger

defmodule EctoTest.Types.LargeInt do
  @behaviour Ecto.Type
  def type do
    Logger.debug "type"
    :string
  end
  def cast(string) when is_binary(string) do
    Logger.debug "cast is_binary"
    {:ok, string}
  end
  def cast(integer) when is_integer(integer) do
    Logger.debug "cast is_integer"
    {:ok, :erlang.integer_to_binary(integer)}
  end

  @doc """
  database type -> custom type
  """
  def load(string) do
    Logger.debug "load"
    {:ok, string |> String.strip |> String.to_integer()}
  end

  @doc """
  custom type -> db type
  """
  def dump(integer) when is_integer(integer) do
    Logger.debug "dump"
    {:ok, Integer.to_string(integer)}
  end
  def dump(_) do
    :error
  end
end
