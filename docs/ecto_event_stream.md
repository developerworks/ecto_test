> 回调模块 `Ecto.Model.Callbacks` 已经在 `2.0` 中被废弃, `1.x` 版本的 Ecto 可以继续使用.

Ecto 提供了 `before_insert`, `after_insert`这样的回调函数来在数据库操作前后做一些事情, 我们经常把这种函数称为`钩子`. 我们这里有一个例子, 用户注册完成后需要向其邮箱发送一封激活邮件. 通常我们在控制器(`UserController`)中实现一个`create`函数用于创建用户, 例如:

```elixir
def create(conn, %{"user" => params}) do
  changeset = User.changeset(%User{}, params)
  case Repo.insert(changeset) do
    {:ok, user} ->
      send_activation_email(user)
    {:error, changeset} ->
      Logger.error "Can not register user"
  end
end
```

注意这段代码可能在整个系统中有很多重复的, 因为可能会在很多地方需要用到用户注册的代码, 比如Web入口, RESTFUL API接口, 等等. 因此, `send_activation_email(user)`必须在每个注册用户的地方调用. 这种相同功能的代码

实现一个事件广播程序(事件管理器), 我们在需要产生事件的地方可以调用`EctoTest.EventManager.broadcast/1`函数来发送一个事件给事件管理器`EctoTest.EventManager`. 它会把事件发送给各个已注册的处理器, 如果该事件是某个处理器需要处理的, 就进入事件处理程序, 如果不是, 事件处理程序会忽略该事件:

```elixir
defmodule EctoTest.EventManager do
  @handlers [
    # 在这里插入事件处理器模块
  ]
  def start_link do
    {:ok, manager} = GenEvent.start_link(name: __MODULE__)
    Enum.each(@handlers, &GenEvent.add_handler(manager, &1, []))
    {:ok, manager}
  end
  def broadcast(event) do
    GenEvent.notify(__MODULE__, event)
  end
end
```

上述事件管理器实际上在软件工程当中实现了一个`发布/订阅`设计模式, `EctoTest.EventManager`是一个事件发布在, `@handlers`属性是一批订阅者, 当有时间产生时, `EctoTest.EventManager`会把这个事件广播出去.

注意, 需要把`EctoTest.EventManager`挂载到监控树下面

```elixir
children = [
  worker(EctoTest.EventManager, [])
]
```

## 广播生命周期事件

一个模型的生命周期实际上就是一堆事件, 比如`insert`, `update`, 和`delete`, 下面我们来创建一个这样的生命周期模块:

```elixir
defmodule EctoTest.ModelLifecycle do
  # Ecto.Model.Callbacks 在 2.0 已经被废弃
  import Ecto.Model.Callbacks
  alias EctoTest.EventManager
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      after_insert :broadcast_event, [:insert]
      after_update :broadcast_event, [:update]
      after_delete :broadcast_event, [:delete]
    end
  end
  # 以如下的格式广播事件
  # {:model, :update, changeset}
  def broadcast_event(changeset, type) do
    EventManager.broadcast({:model, type, changeset})
    changeset
  end
end

```

然后在模型当中使用这个生命周期模块:

```elixir
defmodule EctoTest.Model.User do
  use Ecto.Model
  use EctoTest.ModelLifecyle
  # ...
end
```

现在,当模型在执行`insert`, `update` 和`delete`操作后, 会回自产生这些事件. 通过`GenEvent` API, 我们在可以收到这些通知(事件)时做一些事情. 现在我们来完成上述用户注册后的邮件发送功能, 创建一个`EctoTest.EmailSender`, 它实现了 `GenEvent` 行为:

```elixir
defmodule EctoTest.EmailSender do
  use GenEvent
  alias EctoTest.Model.User
  def handle_event({:model, :insert, %{model: %User{}} = changeset}, state) do
    send_activation_email(changeset.model)
    {:ok, state}
  end
end
```

## 好处

- 一个事件可以设置多个订阅者
- 多个模型的事件处理逻辑可以放在一个位置
- 生命周期事件在单独的进程中处理, 不会阻塞模型的执行流

## 缺点

- 增加了复杂度
- 有可能过度封装, 代码不直观
