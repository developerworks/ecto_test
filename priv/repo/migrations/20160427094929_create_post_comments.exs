defmodule EctoTest.Repo.Migrations.CreatePostComments do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :text
      timestamps
    end

    create table(:comments) do
      add :post_id, references(:posts)
      add :body, :text
      timestamps
    end
  end
end
