defmodule EctoTest.Repo.Migrations.CreateTableChatGroups do
  use Ecto.Migration

  def up do
    create table(:chat_groups) do
      add :name, :string, null: false
      timestamps
    end
  end

  def down do
    drop table(:chat_groups)
  end
end
