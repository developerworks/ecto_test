```elixir
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
```

## 如何使用

```
git clone https://github.com/developerworks/ecto_test.git
mix deps.get
mix compile
iex -S mix
```

## 测试

```
# 插入用户数据

iex(40)> EctoTest.Factory.load_users

# 插入聊天组数据

iex(41)> EctoTest.Factory.load_chat_groups

# 插入用户-聊天组关系数据

iex(42)> EctoTest.Factory.load_chat_group_user

# 查询用户ID为1的用户, 并加载其所在的组列表

iex(47)> user = EctoTest.Model.User |> EctoTest.Repo.get(1) |> EctoTest.Repo.preload(:chat_groups)

# 访问用户所在的组
iex(51)> user.chat_groups

[%EctoTest.Model.ChatGroup{__meta__: #Ecto.Schema.Metadata<:loaded>, chat_group_users: #Ecto.Association.NotLoaded<association :chat_group_users is not loaded>, id: 85, inserted_at: #Ecto.DateTime<2016-04-29 14:19:50>,
  name: "chat_group_84", updated_at: #Ecto.DateTime<2016-04-29 14:19:50>, users: #Ecto.Association.NotLoaded<association :users is not loaded>},
 %EctoTest.Model.ChatGroup{__meta__: #Ecto.Schema.Metadata<:loaded>, chat_group_users: #Ecto.Association.NotLoaded<association :chat_group_users is not loaded>, id: 74, inserted_at: #Ecto.DateTime<2016-04-29 14:19:50>,
  name: "chat_group_73", updated_at: #Ecto.DateTime<2016-04-29 14:19:50>, users: #Ecto.Association.NotLoaded<association :users is not loaded>}]
```
