defmodule EctoTest.Model.ChatGroupUser do
  @moduledoc """

  """
  use EctoTest.Model
  alias EctoTest.Model.ChatGroup
  alias EctoTest.Model.User

  schema "chat_group_users" do
    belongs_to :chat_group, ChatGroup
    belongs_to :user, User
  end

  @spec insert(map) :: {:ok, Schema.t} | {:error, Changeset.t}
  def insert(map) do
    Map.merge(%__MODULE__{}, map) |> Repo.insert
  end
end

