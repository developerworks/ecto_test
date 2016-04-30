defmodule EctoTest.Model.Account do
  use Ecto.Schema
  alias EctoTest.Model.Settings
  schema "accounts" do
    field :name
    embeds_one :settings, Settings
  end
end
