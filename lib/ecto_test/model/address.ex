defmodule EctoTest.Model.Address do
  use Ecto.Schema

  embedded_schema do
    field :street_name
    field :city
    field :state
    field :zip_code
  end
end
