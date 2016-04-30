defmodule EctoTest.Repo.Migrations.CreateTableUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :name, :string, default: ""
      timestamps
    end

    @doc """
    Create an partial index(name != '') on `:name` column of table `users`
    """
    create index(:users, [:name], [unique: true, where: "name != ''"])
  end

  def down do
    drop table(:users)
    drop index(:users, [:name])
  end
end
