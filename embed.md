`Postgres 9.4` 及其以上版本可以存储类似 `arrays`, `json`, `jsonb` 这样的非结构化数据. `Ecto` 作为一个 `Elixir` 的数据封装器, 提供了这些非结构话的数据到 `Elixir` 原生数据类型的序列化和反序列化. 嵌入的记录具有所有常规模型所具有的东西, 比如结构化的字段, 生命周期回调, 变更集. 下面研究如何把结构嵌入到 `Ecto` 模型当中.

## 使用 `embeds_one` 嵌入单个结构

可以使用 `embeds_one` 嵌入单个结构到 `Ecto` 模型当中. 嵌入的字段必须是 `:map` 这种非结构化的的数据类型. 在 `Postgres` 中, `Ecto` 使用了 `jsonb` 作为底层数据库字段的数据类型.

`20160430043543_create_table_account.exs`

```elixir
defmodule EctoTest.Repo.Migrations.CreateTableAccount do
  use Ecto.Migration
  def change do
    create table(:accounts) do
      add :name, :string
      add :settings, :map  # 迁移脚本里面数据类型需要设置为 :map,
                           # 这样 Postgrex 适配器才能正确的把它映射到 jsonb[] 数据类型
    end
  end
end
```

执行项目目录中的 `./migrate` 脚本, 内容如下

```
#!/bin/bash

mix ecto.migrate -r EctoTest.Repo
```

```
➜  ecto_test git:(master) ✗ ./migrate

12:38:10.930 [info]  == Running EctoTest.Repo.Migrations.CreateTableAccount.change/0 forward

12:38:10.930 [info]  create table accounts

12:38:10.943 [info]  == Migrated in 0.0s
```

定义模型

```elixir
defmodule EctoTest.Model.Account do
  use Ecto.Schema
  alias EctoTest.Model.Settings
  schema "accounts" do
    field :name
    embeds_one :settings, Settings
  end
end
```

定义嵌入到 `EctoTest.Model.Account` 模型中的字段:

```elixir
defmodule EctoTest.Model.Settings do
  use Ecto.Model
  embedded_schema do
    field :email_signature
    field :send_emails, :boolean
  end
end
```


嵌入的记录行为上和电信的关联(`associations`)一样, 只是它只能够通过变更集(`changeset`)来更新和删除

插入数据测试

```elixir
# 模拟 EctoTest.get/1 返回一个 %EctoTest.Model.Account() 结构
account = %EctoTest.Model.Account{name: "test"}

# 创建Settings结构
settings = %EctoTest.Model.Settings{email_signature: "developerworks", send_emails: true}

# 创建变更集
changeset = Ecto.Changeset.change(account)

# 嵌入
changeset = Ecto.Changeset.put_embed(changeset, :settings, settings)

# 插入数据
changeset |> EctoTest.Repo.insert!
```

当父记录保存时, 会自动地的调用嵌入模型(`Settings`模型)中的 `changeset/2` 函数.

嵌入的记录可以通过`.`符号来访问, 因此不必考虑在一般的关联关系中的链接`JOIN`和预加载(`preload`)的问题:

```elixir
account = Repo.get!(EctoTest.Model.Account, 1)
account.settings #=> %Settings{...}
```

## 使用 `embeds_many` 嵌入多个结构

`embeds_many` 允许你嵌入一个 Ecto 结构数组到一个关系数据库字段中. 在数据库底层 Postgres 使用了 `array` 和 `jsonb` 数据类型来实现 `embeds_many`.

```elixir
defmodule MyApp.Repo.Migrations.CreatePeople do
  use Ecto.Migration
  def change do
    alter table(:people) do
      add :name, :string
      # It is recommended to set the default value to an empty array.
      add :addresses, {:array, :map}, default: []
    end
  end
end
```

定义 `Person`, `Address` 模型:

```elixir
defmodule Person do
  use Ecto.Model

  schema "people" do
    field :name
    embeds_many :addresses, Address
  end
end

defmodule Address do
  use Ecto.Model

  embedded_schema do
    field :street_name
    field :city
    field :state
    field :zip_code
  end
end
```

设置多对多字段的值

```elixir
person = Repo.get!(Person, 7)
addresses = [
  %Address{
    street_name: "20 Foobar Street",
    city: "Boston",
    state: "MA",
    zip_code: "02111"
  },
  %Address{
    street_name: "1 Finite Loop",
    city: "Cupertino",
    state: "CA",
    %zip_code: "95014"
  },
]

changeset = Ecto.Changeset.change(person)
changeset = Ecto.Changeset.put_change(person, :addresses, addresses)

Repo.update!(changeset)
```

像 `has_many` 一样访问:

```elixir
person = Repo.get!(Person, 5)
person.addresses #=> [%Address{...}, %Address{...}]
```

## 权衡

记录的嵌入是 `Ecto` 提供的多个强大的能之一. 很容易给嵌入的记录添加字段, 不需要运行时修改数据库结构. 这些都是优势, 但有的场景下也会带来一些问题, 因此需要权衡是否应该使用嵌入.

使用非结构化数据, 丢失了SQL数据库提供的关系特性, 例如, 一个记录只能嵌入到一个父表中, 因此不能使用嵌入建模多对多关系, 也不能使用数据库约束, 虽然可以在应用程序中检查数据的完整性, 但是更好的方式是在数据库级别进行验证, 以保障数据的完整性.
