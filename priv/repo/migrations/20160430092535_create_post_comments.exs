defmodule EctoTest.Repo.Migrations.CreatePostComments do
  use Ecto.Migration

  def up do
    create table(:posts) do
      add :title, :string
      add :body, :text
      add :votes, :integer, default: 0
      add :permalinks, {:array, :map}, default: []
      timestamps
    end
    create table(:comments) do
      add :post_id, references(:posts)
      add :body, :text
      timestamps
    end
  end

  def down do
    drop table(:comments)
    drop table(:posts)
  end
end
