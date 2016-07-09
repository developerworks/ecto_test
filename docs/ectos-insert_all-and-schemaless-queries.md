Ecto 2.0 中新加了一个函数 [Ecto.Repo.insert_all/3](https://hexdocs.pm/ecto/2.0.0-rc.1/Ecto.Repo.html#c:insert_all/3). `insert_all` 让开发者能够一次插入多行数据到数据库中, 例如:

```elixir
alias EctoTest.Model.Post
datetime = Ecto.DateTime.utc
EctoTest.Repo.insert_all(Post, [
  [title: "事件流处理和回调", body: "回调模块Ecto.Model.Callbacks已经在2.0 中被废弃", inserted_at: datetime, updated_at: datetime],
  [title: "自定义数据类型", body: "为什么需要自定义的数据类型?", inserted_at: datetime, updated_at: datetime]
])
```

## 模式(Schema)的问题

