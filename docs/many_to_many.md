本文是参考下面的文章做的一个实际例子
[http://blog.plataformatec.com.br/2015/08/working-with-ecto-associations-and-embeds/](http://blog.plataformatec.com.br/2015/08/working-with-ecto-associations-and-embeds/)
[http://learningwithjb.com/posts/many-to-many-relationship](http://learningwithjb.com/posts/many-to-many-relationship)
[http://stackoverflow.com/questions/32900114/many-to-many-relationship-in-ecto](http://stackoverflow.com/questions/32900114/many-to-many-relationship-in-ecto)


## 代码库

[https://github.com/developerworks/ecto_test](https://github.com/developerworks/ecto_test)

## 定义多对多关系

创建移植脚本

```
mix ecto.gen.migration create_table_users -r EctoTest.Repo
mix ecto.gen.migration create_table_chat_groups -r EctoTest.Repo
mix ecto.gen.migration create_table_chat_group_users -r EctoTest.Repo
```

移植脚本的内容分别为:

`20160429075137_create_table_users.exs`

```elixir
defmodule EctoTest.Repo.Migrations.CreateTableChatGroupUsers do
  use Ecto.Migration

  def up do
    create table(:chat_group_users) do
      add :user_id,  references(:users)
      add :group_id, references(:chat_groups)
      timestamps
    end
  end

  def down do
    drop table(:chat_group_users)
  end
end
```

`20160429075138_create_table_chat_groups.exs`

```elixir
defmodule EctoTest.Repo.Migrations.CreateTableChatGroups do
  use Ecto.Migration

  def up do
    create table(:chat_groups) do
      add :name, :string, null: false
    end
  end

  def down do
    drop table(:chat_groups)
  end
end
```

`20160429075146_create_table_chat_group_users.exs`

```elixir
defmodule EctoTest.Repo.Migrations.CreateTableChatGroupUsers do
  use Ecto.Migration

  def up do
    create table(:chat_group_users) do
      add :user_id,  references(:users)
      add :group_id, references(:chat_groups)
      timestamps
    end
  end

  def down do
    drop table(:chat_group_users)
  end
end
```

执行移植

```
➜  ecto_test git:(master) ✗ mix ecto.migrate -r EctoTest.Repo

16:14:05.200 [info]  == Running EctoTest.Repo.Migrations.CreateTableChatGroupUsers.up/0 forward

16:14:05.200 [info]  create table chat_group_users

16:14:05.211 [info]  == Migrated in 0.0s
```

模型代码分别为

`lib/ecto_test/model/user.ex`

```elixir
defmodule EctoTest.Model.User do
  @moduledoc """

  """
  use EctoTest.Model
  alias EctoTest.Model.ChatGroupUser

  schema "users" do
    field :name, :string, null: false
    has_many :chat_group_users, ChatGroupUser
    has_many :chats, through: [:chat_group_users, :chat]
    timestamps
  end

  @spec insert(map) :: {:ok, Schema.t} | {:error, Changeset.t}
  def insert(map) do
    Map.merge(%__MODULE__{}, map) |> Repo.insert
  end
end
```

`lib/ecto_test/model/chat_group.ex`

```elixir
defmodule EctoTest.Model.ChatGroup do
  @moduledoc """

  """
  use EctoTest.Model
  alias EctoTest.Model.ChatGroupUser

  schema "chat_groups" do
    field :name, :string, null: false
    has_many :chat_group_users, ChatGroupUser
    has_many :users, through: [:chat_group_users, :user]
  end

  @spec insert(map) :: {:ok, Schema.t} | {:error, Changeset.t}
  def insert(map) do
    Map.merge(%__MODULE__{}, map) |> Repo.insert
  end
end
```

`lib/ecto_test/model/chat_group_user.ex`

```elixir
defmodule ChatGroupUser do
  @moduledoc """

  """
  use EctoTest.Model
  alias EctoTest.Model.ChatGroup

  schema "chat_group_users" do
    belongs_to :chat_group, ChatGroup
    belongs_to :user, User
    timestamps
  end

  @spec insert(map) :: {:ok, Schema.t} | {:error, Changeset.t}
  def insert(map) do
    Map.merge(%__MODULE__{}, map) |> Repo.insert
  end
end
```

## 读取多对多关系

插入`用户`数据

```
iex(1)> user = %EctoTest.Model.User{name: "user1"} |> EctoTest.Repo.insert!

16:48:47.128 [debug] QUERY OK db=0.2ms
begin []

16:48:47.149 [debug] QUERY OK db=1.3ms
INSERT INTO "users" ("inserted_at","updated_at","name") VALUES ($1,$2,$3) RETURNING "id" [{{2016, 4, 29}, {8, 48, 47, 0}}, {{2016, 4, 29}, {8, 48, 47, 0}}, "user1"]

16:48:47.149 [debug] QUERY OK db=0.5ms
commit []
%EctoTest.Model.User{__meta__: #Ecto.Schema.Metadata<:loaded>,
 chat_group_users: #Ecto.Association.NotLoaded<association :chat_group_users is not loaded>,
 chats: #Ecto.Association.NotLoaded<association :chats is not loaded>, id: 1,
 inserted_at: #Ecto.DateTime<2016-04-29 08:48:47>, name: "user1",
 updated_at: #Ecto.DateTime<2016-04-29 08:48:47>}
```

插入`聊天组`数据

```elixir
chat_group = %EctoTest.Model.ChatGroup{name: "chat_group2"} |> EctoTest.Repo.insert!
user = %EctoTest.Model.User{name: "user2"} |> EctoTest.Repo.insert!
%EctoTest.Model.ChatGroupUser{user_id: user.id, chat_group_id: chat_group.id} |> EctoTest.Repo.insert!
```

读取用户, 以及用户的聊天组

```elixir
EctoTest.Model.User |> EctoTest.Repo.get(1) |> EctoTest.Repo.preload(:chat_groups)
```

或调用 `EctoTest.Model.User.get(1)`

## `Ecto` 的 `Mix` 命令

```
mix ecto.create        # Creates the repository storage
mix ecto.drop          # Drops the repository storage
mix ecto.dump          # Dumps database structure
mix ecto.gen.migration # Generate a new migration for the repo
mix ecto.gen.repo      # Generate a new repository
mix ecto.load          # Loads previously dumped database structure
mix ecto.migrate       # Runs the repository migrations
mix ecto.rollback      # Rolls back migrations
```
