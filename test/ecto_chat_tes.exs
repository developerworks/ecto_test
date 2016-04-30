defmodule EctoChatTest do
  use ExUnit.Case
  use Readdit.ConnCase

  setup do
    chat_group = %EctoTest.Model.ChatGroup{name: "chat_group2"}
      |> EctoTest.Repo.insert!

    user = %EctoTest.Model.User{name: "user2"}
      |> EctoTest.Repo.insert!

    %EctoTest.Model.ChatGroupUser{user_id: user.id, chat_group_id: chat_group.id}
      |> EctoTest.Repo.insert!
    {:ok, chat_group_id: chat_group.id, user_id: user.id}
  end

  test "get group members", context do
    chat_group = EctoTest.Model.ChatGroup
      |> EctoTest.Repo.get(context[:chat_group_id])
      |> EctoTest.Repo.preload(:users)

    assert chat_group.name == "chat_group2"
    assert Enum.count(chat_group.users) >= 1
  end

  test "get user groups", context do
    user = EctoTest.Model.User
      |> EctoTest.Repo.get(context[:user_id])
      |> EctoTest.Repo.preload(:chat_groups)

    assert user.name == "user2"
    assert Enum.count(user.chat_groups) >= 1
  end

end
