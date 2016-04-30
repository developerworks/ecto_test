
# Elixir Ecto: 入门上手

![图片描述][1]

## 简介

`Ecto`分为4个主要组件

| 组件 | 说明
| --- | ---
| `Ecto.Repo` | 数据库包装器, 通过它可以执行创建,更新,删除和查询等数据库操作, 它需要一个适配器和一个URL与数据库通信
| `Ecto.Schema` | 允许开发者定义映射到底层存储的数据结构
| `Ecto.Changeset` | 为开发者提供了一个过滤和转换外部参数的方法, 以及在发送到数据库之前追踪和验证变更的机制.
| `Ecto.Query` | 以Elixir语法编写查询, 从数据库检索信息. 在Ecto中查询是安全的, 避免了类似SQL注入, 等常见的问题. 并提供类型安全. 通过`Ecto.Queryable`协议, 查询是可组合的

## 配置`Ecto`

本节包含详细的创建, 配置, 开发一个Ecto项目的完整过程. 本文基于 `Ecto 2.0.0-rc`版本, 演示下面的过程.

### 创建项目

```
➜  /tmp> mix new ecto_test
* creating README.md
* creating .gitignore
* creating mix.exs
* creating config
* creating config/config.exs
* creating lib
* creating lib/ecto_test.ex
* creating test
* creating test/test_helper.exs
* creating test/ecto_test_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

    cd ecto_test
    mix test

Run "mix help" for more commands.
```

### 添加依赖

```elixir
defp deps do
  [
    {:mariaex, "~> 0.7.4"},
    {:ecto, "~> 2.0.0-rc.3"}
  ]
end
```

### 设置OTP应用

```
def application do
  [applications: [:logger, :mariaex, :ecto]]
end
```

### 获取依赖

```
➜  ecto_test> mix deps.get
A new Hex version is available (0.11.5), please update with `mix local.hex`
Running dependency resolution
Dependency resolution completed
  connection: 1.0.2
  db_connection: 0.2.5
  decimal: 1.1.2
  ecto: 2.0.0-rc.3
  mariaex: 0.7.4
  poolboy: 1.5.1
* Getting mariaex (Hex package)
Checking package (https://s3.amazonaws.com/s3.hex.pm/tarballs/mariaex-0.7.4.tar)
Fetched package
* Getting ecto (Hex package)
Checking package (https://s3.amazonaws.com/s3.hex.pm/tarballs/ecto-2.0.0-rc.3.tar)
Fetched package
* Getting poolboy (Hex package)
Checking package (https://s3.amazonaws.com/s3.hex.pm/tarballs/poolboy-1.5.1.tar)
Using locally cached package
* Getting decimal (Hex package)
Checking package (https://s3.amazonaws.com/s3.hex.pm/tarballs/decimal-1.1.2.tar)
Using locally cached package
* Getting db_connection (Hex package)
Checking package (https://s3.amazonaws.com/s3.hex.pm/tarballs/db_connection-0.2.5.tar)
Using locally cached package
* Getting connection (Hex package)
Checking package (https://s3.amazonaws.com/s3.hex.pm/tarballs/connection-1.0.2.tar)
Using locally cached package
```

### 配置数据库

在`config/config.exs`配置文件中添加如下配置:

```elixir
config :ecto_test, EctoTest.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "ecto_test",
  username: "root",
  password: "root",
  hostname: "192.168.212.129"

# URL 配置方式
config :ecto_test, ecto_repos: [EctoTest.Repo]
  url: "mysql://root:root@192.168.212.129/ecto_test"
```

关于数据库配置的详细参数, 参考 [https://hexdocs.pm/ecto/2.0.0-rc.1/Ecto.Adapters.MySQL.html](https://hexdocs.pm/ecto/2.0.0-rc.1/Ecto.Adapters.MySQL.html)


### 编写`Repo`模块

创建`lib/ecto_test`目录, 并在其中创建文件`repo.ex`, 内容如下:

```elixir
defmodule EctoTest.Repo do
  use Ecto.Repo, otp_app: :ecto_test
end
```

### 编译

```
➜  ecto_test> mix compile
==> connection
Compiled lib/connection.ex
Generated connection app
==> poolboy (compile)
Compiled src/poolboy_sup.erl
Compiled src/poolboy_worker.erl
Compiled src/poolboy.erl
==> decimal
Compiled lib/decimal.ex
Generated decimal app
==> db_connection
Compiled lib/db_connection/app.ex
Compiled lib/db_connection/error.ex
Compiled lib/db_connection/log_entry.ex
...
...
...
```

### 创建数据库

```
➜  ecto_test> mix ecto.create -r EctoTest.Repo
The database for EctoTest.Repo has been created
```

上面的输出提示, 底层的数据库已经创建完成.

## 创建模型和迁移(Migration)

这一节正式开始说明如何创建模型模块, 和迁移模块

### 创建模型

```elixir
defmodule EctoTest.Domain do
  use Ecto.Schema
  schema "domain" do
    field :url
    timestamps
  end
end
```


### 创建移植脚本

创建一个空的移植脚本

```
➜  ecto_test> mix ecto.gen.migration add_domain_table -r EctoTest.Repo
* creating priv/repo/migrations
* creating priv/repo/migrations/20160427032452_add_domain_table.exs
```

修改移植脚本`priv/repo/migrations/20160427032452_add_domain_table.exs`, 为如下内容, 移植脚本默认会创建在项目根目录的`priv`子目录中. 该目录的位置可以在数据库配置中, 通过指定`:priv`键设置.

```elixir
defmodule EctoTest.Repo.Migrations.AddDomainTable do
  use Ecto.Migration

  def change do
    create table(:domain) do
      add :url, :string
      timestamps
    end
  end
end
```

### 执行表的创建

```
➜  ecto_test> mix ecto.migrate -r EctoTest.Repo

11:29:30.396 [info]  == Running EctoTest.Repo.Migrations.AddDomainTable.change/0 forward
11:29:30.396 [info]  create table domain
11:29:30.406 [info]  == Migrated in 0.0s
```

## 在IEx中测试

```
iex(3)> domain = %EctoTest.Domain{url: "https://segmentfault.com/u/developerworks"}
%EctoTest.Domain{__meta__: #Ecto.Schema.Metadata<:built>, id: nil, inserted_at: nil, updated_at: nil, url: "https://segmentfault.com/u/developerworks"}

iex(4)> domain |> EctoTest.Repo.insert

12:04:36.455 [debug] QUERY OK db=10.0ms queue=0.1ms
INSERT INTO `domain` (`inserted_at`,`updated_at`,`url`) VALUES (?,?,?) [{{2016, 4, 27}, {4, 4, 36, 0}}, {{2016, 4, 27}, {4, 4, 36, 0}}, "https://segmentfault.com/u/developerworks"]
{:ok, %EctoTest.Domain{__meta__: #Ecto.Schema.Metadata<:loaded>, id: 2, inserted_at: #Ecto.DateTime<2016-04-27 04:04:36>, updated_at: #Ecto.DateTime<2016-04-27 04:04:36>, url: "https://segmentfault.com/u/developerworks"}}
iex(5)>
```


  [1]: https://segmentfault.com/img/bVvdlk

