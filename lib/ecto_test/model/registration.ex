defmodule EctoTest.Model.Registration do
  @moduledoc """
  Database <-> Ecto schema <-> Forms / API

  http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  """
  use Ecto.Schema

  embedded_schema do
    field :first_name
    field :last_name
    field :email
  end
end
