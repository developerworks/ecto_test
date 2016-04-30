defmodule EctoTest.ModelLifecycle do
  # 2.0 已经被废弃
  # import Ecto.Model.Callbacks
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
