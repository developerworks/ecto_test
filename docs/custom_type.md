## 为什么需要自定义的数据类型?

> **需求**:
> 系统中需要存储超过Postgres的`int8`(8字节, 64位)的整数, 那只有把它存储为字符串了.

> **原因**:
> 因为, 在我的Elixir项目中这个`hash`值用到了很多很多地方, 类型是整数, 并且用于二进制协议的解析和编码, 我想要的效果就是从数据库出来的数据到程序中就是我期望的类型, 而不是在程序中到处用`:erlang.string_to_integer/1`来做转换, 这样可以让代码更加简洁一点. 就这么一个用途, 没别的了.

## 创建移植脚本

首先, 我们需要创建一个移植脚本, 来在Postgres中创建一张名为`large_int`的表

```
➜  ecto_test git:(master) ✗ mix ecto.gen.migration create_table_large_int -r EctoTest.Repo
* creating priv/repo/migrations
* creating priv/repo/migrations/20160430092534_create_table_large_int.exs
```

内容如下:

```elixir
defmodule EctoTest.Repo.Migrations.CreateTableLargeInt do
  use Ecto.Migration

  def up do
    create table(:large_int) do
      add :hash, :char, size: 32 # CHAR(32)
                                 # 数据库的字段类型为CHAR(32),下图中也可以看到
    end
  end

  def down do
    drop table(:large_int)
  end
end
```

然后切换到终端执行`mix ecto.migrate -r EctoTest.Repo`创建数据库表

```
➜  ecto_test git:(master) ✗ mix ecto.migrate -r EctoTest.Repo

17:48:43.425 [info]  == Running EctoTest.Repo.Migrations.CreateTableLargeInt.up/0 forward

17:48:43.425 [info]  create table large_int

17:48:43.434 [info]  == Migrated in 0.0s
```
如果看到上面的信息, 说明表以已经创建好了,我们用一张美图来瞅一下表的结构和定义

![图片描述][1]

## 实现自定义数据类型

```elixir
defmodule EctoTest.Types.LargeInt do
  @behaviour Ecto.Type
  def type, do: :string
  def cast(string) when is_binary(string) do
    {:ok, string}
  end
  def cast(integer) when is_integer(integer) do
    {:ok, :erlang.integer_to_binary(integer)}
  end
  def load(string), do: {:ok, string |> String.strip |> String.to_integer()}
  def dump(integer) when is_integer(integer), do: {:ok, Integer.to_string(integer)}
  def dump(_), do: :error
end
```

如何实现自定义数据类型, 可以参考 [Ecto.Type Callbacks 文档](https://hexdocs.pm/ecto/2.0.0-rc.3/Ecto.Type.html#callbacks)

## 创建模型

```elixir
defmodule EctoTest.Model.LargeInt do
  @moduledoc """
  A large integer that can be store as a string to database
  in postgres
  """
  use Ecto.Schema
  alias EctoTest.Repo
  alias EctoTest.Types.LargeInt

  schema "large_int" do
    field :hash, LargeInt # 引用自定义类型
  end

  def test do
    %__MODULE__{hash: 17620097757106081354}
    |> Repo.insert!
  end

  def get(id) do
    __MODULE__ |> Repo.get(id)
  end
end

```

模型中包含了一个`test/0`函数, 用于向数据库中插入数据, 现在切换到终端, 编译一下项目 `mix compile`, 然后启动应用 `iex -S mix`

执行这个`test/0`方法, 我们看一下结果, 我用一张美图来演示:

![图片描述][2]

切换到数据库, 看看数据是怎么样的:

![图片描述][3]

最后, 我们来看看, 读取出来的效果:

![图片描述][4]

中间遇到一个错误, 数据库的字段是`32`字符的`CHAR`, 调用 `:erlang.string_to_integer/1`出错, 修改自定义数据类型模块, 用 `String.strip/1` 把空格去掉.

![图片描述][5]

好了, 自定义数据就说到这里了. 项目的仓库在 https://github.com/developerworks/ecto_test 上, 需要测试的可以去clone下来测试.

## 2016-05-03 补充

关于自定数据类型的实现, 入库和出库调用的函数.

![图片描述][6]


  [1]: https://segmentfault.com/img/bVviU6
  [2]: https://segmentfault.com/img/bVviVY
  [3]: https://segmentfault.com/img/bVviV4
  [4]: https://segmentfault.com/img/bVviWC
  [5]: https://segmentfault.com/img/bVviWG
  [6]: https://segmentfault.com/img/bVvlRs
