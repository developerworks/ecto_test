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

  def test_insert do
    changeset = Ecto.Changeset.change(%__MODULE__{})
    changeset = Ecto.Changeset.put_embed(changeset, :permalinks, [
      %Permalink{url: "example.com/thebest"},
      %Permalink{url: "another.com/mostaccessed"}
    ])
    post = Repo.insert!(changeset)
  end
end
