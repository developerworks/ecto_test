defmodule EctoTest.Repo.Migrations.CreateTableChatGroupUsers do
  use Ecto.Migration

  def up do
    create table(:chat_group_users) do
      add :user_id,       references(:users)
      add :chat_group_id, references(:chat_groups)
      timestamps
    end
  end

  def down do
    drop table(:chat_group_users)
  end


end
