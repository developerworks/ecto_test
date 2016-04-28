defmodule EctoTest.Comment do
  use Ecto.Schema

  schema "comments" do
    field :body
    belongs_to :post, EctoTest.Post
    timestamps
  end
end
