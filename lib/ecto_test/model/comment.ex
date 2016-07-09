defmodule EctoTest.Model.Comment do
  use Ecto.Schema

  schema "comments" do
    field :body
    belongs_to :post, EctoTest.Model.Post
    timestamps
  end
end
