defmodule EctoTest.Repo.Migrations.CreateTableUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :name, :string, null: false
      timestamps
    end
  end

  def down do
    drop table(:users)
  end
end
