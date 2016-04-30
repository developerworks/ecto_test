defmodule EctoTest.Model.LargeInt do
  @moduledoc """
  A large integer that can be store as a string to database
  in postgres
  """
  use Ecto.Schema
  alias EctoTest.Repo
  alias EctoTest.Types.LargeInt

  schema "large_int" do
    field :hash, LargeInt # 引用自定义类型
  end

  def test do
    %__MODULE__{hash: 17620097757106081354}
    |> Repo.insert!
  end

  def get(id) do
    __MODULE__ |> Repo.get(id)
  end
end
