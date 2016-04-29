defmodule EctoTest.Factory do
  use ExMachina.Ecto, repo: EctoTest.Repo
  alias EctoTest.Model.User
  alias EctoTest.Model.ChatGroup
  alias EctoTest.Model.ChatGroupUser

  def factory(:users) do
    %User{
      # name: "Jane Smith",
      name: sequence(:name, &"user#{&1}"),
    }
  end

  def factory(:chat_groups) do
    %ChatGroup{
      name: sequence(:name, &"chat_group_#{&1}")
    }
  end

  def factory(:chat_group_users) do
    %ChatGroupUser{
      user_id: :rand.uniform(100),
      chat_group_id: :rand.uniform(100)
    }
  end

  def load_users do
    for _n <- 1..100 do
      create :users
    end
  end

  def load_chat_groups do
    for _n <- 1..100 do
      create :chat_groups
    end
  end

  def load_chat_group_users do
    for _n <- 1..200 do
      create :chat_group_users
    end
  end
end
