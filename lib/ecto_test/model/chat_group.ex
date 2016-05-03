defmodule EctoTest.Model.ChatGroup do
  @moduledoc """

  """
  use EctoTest.Model
  alias EctoTest.Model.ChatGroupUser

  schema "chat_groups" do
    field :name, :string, null: false

    has_many :chat_group_users, ChatGroupUser, on_delete: :delete_all
    has_many :users, through: [:chat_group_users, :user]
    timestamps
  end

  @spec insert(map) :: {:ok, Schema.t} | {:error, Changeset.t}
  def insert(map) do
    Map.merge(%__MODULE__{}, map) |> Repo.insert
  end

  def get(id) do
    EctoTest.Model.ChatGroup
    |> Repo.get(id)
    |> Repo.preload(:users)
  end
end

