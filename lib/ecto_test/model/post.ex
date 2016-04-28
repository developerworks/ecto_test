defmodule EctoTest.Post do
  use Ecto.Schema

  schema "posts" do
    field :title
    field :body
    has_many :comments, EctoTest.Comment
    timestamps
  end
end
