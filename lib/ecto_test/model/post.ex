defmodule EctoTest.Post do
  use Ecto.Schema
  alias EctoTest.Repo
  alias EctoTest.Permalink

  schema "posts" do
    field :title
    field :body
    # has_many :comments, EctoTest.Comment
    embeds_many :permalinks, EctoTest.Permalink
    timestamps
  end

  def get(id) do
    Repo.get __MODULE__, id
  end

  def get_by(id) do
    Repo.get_by __MODULE__, id: id
  end

  def test_insert do
    changeset = Ecto.Changeset.change(%__MODULE__{})
    changeset = Ecto.Changeset.put_embed(changeset, :permalinks, [
      %Permalink{url: "example.com/thebest"},
      %Permalink{url: "another.com/mostaccessed"}
    ])
    Repo.insert!(changeset)
  end
end
