defmodule EctoTest.Model.Post do
  use Ecto.Schema
  alias EctoTest.Repo
  alias EctoTest.Permalink

  schema "posts" do
    field :title
    field :body
    field :votes, :integer, default: 0
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

  def test_insert_all do
    datetime = Ecto.DateTime.utc
    __MODULE__
    |> EctoTest.Repo.insert_all([
      [
        title: "事件流处理和回调",
        body: "回调模块Ecto.Model.Callbacks已经在2.0 中被废弃",
        votes: 129,
        permalinks: [
          %Permalink{url: "example.com/thebest"},
          %Permalink{url: "another.com/mostaccessed"}
        ],
        inserted_at: datetime, updated_at: datetime
      ],
      [
        title: "自定义数据类型",
        body: "为什么需要自定义的数据类型?",
        votes: 321,
        permalinks: [
          %Permalink{url: "example.com/thebest"},
          %Permalink{url: "another.com/mostaccessed"}
        ],
        inserted_at: datetime,
        updated_at: datetime
      ]
    ])
  end
end
