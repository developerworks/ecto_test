defmodule EctoTest.Repo.Migrations.CreateTableLargeInt do
  use Ecto.Migration

  def up do
    create table(:large_int) do
      add :hash, :char, size: 32 # CHAR(32)
    end
  end

  def down do
    drop table(:large_int)
  end

end
