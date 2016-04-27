defmodule EctoTest.Model.Domain do
  use EctoTest.Model
  schema "domain" do
    field :url, :string
    timestamps
  end
end
