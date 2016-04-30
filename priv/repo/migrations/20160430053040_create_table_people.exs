defmodule EctoTest.Repo.Migrations.CreateTablePeople do
  use Ecto.Migration

  def up do
    create table(:people) do
      add :name, :string
      add :addresses, {:array, :map}, default: []
    end
  end

  def down do
    drop table(:people)
  end
end
