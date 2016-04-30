defmodule EctoTest.EventManager do
  use GenEvent
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
