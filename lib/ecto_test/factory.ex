defmodule EctoTest.Factory do
  use ExMachina.Ecto, repo: EctoTest.Repo
  alias EctoTest.Model.User
  alias EctoTest.Model.ChatGroup
  alias EctoTest.Model.ChatGroupUser

  @doc """
  factory 是一个数据行的生成器, 生成一个Ecto结构, 这个结构随后可作为
  create 函数的参数, 让 create 函数把这个结构插入到数据库
  """
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

  @doc """
  向用户数据表调入数据
  """
  def load_users do
    for _n <- 1..100 do
      create :users
    end
  end

  @doc """
  导入组表
  """
  def load_chat_groups do
    for _n <- 1..100 do
      create :chat_groups
    end
  end

  @doc """
  导入用户组关系表
  """
  def load_chat_group_users do
    for _n <- 1..200 do
      create :chat_group_users
    end
  end
end
