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
