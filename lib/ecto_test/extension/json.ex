defmodule EctoTest.Extension.JSON do
  alias Postgrex.TypeInfo
  @behaviour Postgrex.Extension
  @json ["json", "jsonb"]

  def init(_params, opts) do
    Keyword.fetch!(opts, :library)
  end

  def matching(_library) do
    [type: "json", type: "jsonb"]
  end

  def format(_library) do
    :binary
  end

  def encode(%TypeInfo{type: "json"}, map, _state, library) do
    library.encode!(map)
  end

  def encode(%TypeInfo{type: "jsonb"}, map, _state, library) do
    <<1, library.encode!(map)::binary>>
  end

  def decode(%TypeInfo{type: "json"}, json, _state, library) do
    library.decode!(json)
  end

  def decode(%TypeInfo{type: "jsonb"}, <<1, json::binary>>, _state, library) do
    library.decode!(json)
  end
end
