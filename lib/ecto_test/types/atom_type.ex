defmodule EctoTest.Types.AtomType do
  @moduledoc """
  本模块演示了如何实现Ecto的自定义类型

  - 首先需要声明本模块实现 `Ecto.Type` 行为

      @behaviour Ecto.Type

  - 其次需要实现 `Ecto.Type` 行为的4个函数: `type/0`, `cast/1`, `load/1`, `dump/1`

      `type/0` 用于告诉 Ecto 底层数据库的实际数据类型
      `cast/1` 用于把Elixir的变量值转换为能够在数据库中实际存储的值
      `load/1` 用于把从数据库获取到的值转换为在Elixir代码中能够使用的值
      `dump/1` 用于

  不管你实现的是什么自定义类型, 最终都要通过Ecto存储到数据库, 你的自定义类型必须能够
  映射到Ecto支持的类型, 然后通过Ecto的适配器存储到后端数据库
  """
  @behaviour Ecto.Type

  def type, do: :string
  def cast(value), do: {:ok, value}
  def load(value), do: {:ok, String.to_atom(value)}
  def dump(value) when is_atom(value), do: {:ok, Atom.to_string(value)}
  def dump(_), do: :error
end
