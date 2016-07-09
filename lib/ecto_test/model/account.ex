defmodule EctoTest.Model.Account do
  use Ecto.Schema
  alias EctoTest.Model.Settings
  schema "accounts" do
    field :name
    embeds_one :settings, Settings
  end

  def test_insert do
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
  end
end
