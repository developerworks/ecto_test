defmodule EctoTest.Model.JsonFieldTest do

  use Ecto.Schema
  alias EctoTest.Repo
  alias EctoTest.Types.Json

  schema "json_field_test" do
    field :photo, Json # 引用自定义类型
    timestamps
  end

  def test do
    row = %__MODULE__{
      photo: %{
        photo_id: 1,
        photo_small: %{
          dc_id: 5,
          volume_id: 851423320,
          local_id: 5712,
          secret: 16677405481400301998
        },
        photo_big: %{
          dc_id: 5,
          volume_id: 851423320,
          local_id: 5714,
          secret: 17094257132172937085
        }
      }
    }
    Repo.insert(row)
  end

  def get(id) do
    __MODULE__ |> Repo.get(id)
  end
end
