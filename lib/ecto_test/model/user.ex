defmodule EctoTest.Model.User do
  @moduledoc """

  """
  use EctoTest.Model
  alias EctoTest.Model.ChatGroupUser

  schema "users" do
    field :name,  :string, null: false
    # field :phone, :string, null: false

    has_many :chat_group_users, ChatGroupUser, on_delete: :delete_all
    has_many :chat_groups, through: [:chat_group_users, :chat_group]
    timestamps
  end

  @spec insert(map) :: {:ok, Schema.t} | {:error, Changeset.t}
  def insert(map) do
    Map.merge(%__MODULE__{}, map) |> Repo.insert
  end
end
