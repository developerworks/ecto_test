defmodule EctoTest.Repo.Migrations.CreateTableAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      add :settings, :map  # 迁移脚本里面数据类型需要设置为 :map,
                           # 这样 Postgrex 适配器才能正确的把它映射到 jsonb[] 数据类型
    end
  end
end
