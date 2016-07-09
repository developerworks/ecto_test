defmodule EctoTest.Repo.Migrations.CreateJsonFieldTestTable do
  use Ecto.Migration

  def up do
    create table(:json_field_test) do
      add :photo, :json
      timestamps
    end
  end

  def down do
    drop table(:json_field_test)
  end
end
