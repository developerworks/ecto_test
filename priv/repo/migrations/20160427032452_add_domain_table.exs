defmodule EctoTest.Repo.Migrations.AddDomainTable do
  use Ecto.Migration

  def change do
    create table(:domain) do
      add :url, :string
      timestamps
    end
  end
end
