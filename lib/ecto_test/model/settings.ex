defmodule EctoTest.Model.Settings do
  use Ecto.Schema
  embedded_schema do
    field :email_signature
    field :send_emails, :boolean
  end
end
