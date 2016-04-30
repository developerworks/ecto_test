defmodule EctoTest.Model.Person do
  use Ecto.Schema
  alias EctoTest.Repo
  alias EctoTest.Model.Address

  schema "people" do
    field :name
    embeds_many :addresses, Address
  end

  def test_insert do
    changeset = Ecto.Changeset.change(%__MODULE__{})
    addresses = [
      %Address{street_name: "20 Foobar Street",city: "Boston",state: "MA",zip_code: "02111"},
      %Address{street_name: "1 Finite Loop", city: "Cupertino",state: "CA",zip_code: "95014"}
    ]
    changeset = Ecto.Changeset.put_embed(changeset, :addresses, addresses)
    Repo.insert!(changeset)
  end
end
