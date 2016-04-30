# Elixir: 使用Mixin实现OOP的继承效果

## 原理

使用`use`以宏的方式把代码注入到实例模块中, 作用类似其他语言中的抽象基类, 或`Mixin`

## 说明

先上一段代码, 可以把它认为是一个基类模块, 子类模块可以继承这个基类中已经实现了的方法(函数)

基类模块

```elixir
require Logger
defmodule EctoTest.Model do
  @moduledoc """
  """
  @callback get(String.t | Integer.t) :: Schema.t
  @callback insert(Map.t) :: {:ok, Schema.t} | {:error, Changeset.t}

  defmacro __using__(_opts) do
    quote do
      @behaviour EctoTest.Model
      alias Ecto.Schema
      alias Ecto.Changeset
      alias EctoTest.Repo
      import Ecto.Query
      use Ecto.Schema
      @spec get(String.t | Integer.t) :: Schema.t
      def get(id) do
        Repo.get __MODULE__, id
      end
      def all do
        q = from m in __MODULE__, select: m
        q |> Repo.all
      end
      @spec insert(map) :: {:ok, Schema.t} | {:error, Changeset.t}
      def insert(map) do
        Map.merge(map) |> Repo.insert
      end
      defoverridable [get: 1, insert: 1]
    end
  end
end
```

子类模块, 注意在子类模块中我们并没有定义`get/1`函数, 但是我们仍能够使用

```elixir
defmodule EctoTest.Model.Domain do
  use EctoTest.Model
  schema "domain" do
    field :url, :string
    timestamps
  end
end
```

## 在IEx中测试

```
iex(5)> EctoTest.Model.Domain.
__changeset__/0    __schema__/1       __schema__/2       __struct__/0
all/0              get/1
```

在`EctoTest.Model.Domain`中, 我们仍能看到`get/1`存在. 到这里我们看到`EctoTest.Model.Domain`子模块, 从`EctoTest.Model`模块继承了`get/1`函数, 实现了OO继承效果.


> 实际上面向对象编程语言在实现继承的时候是由编译器帮你把基类的代码注入到子类当中的, 本质上代码复用的原理是一样的.

