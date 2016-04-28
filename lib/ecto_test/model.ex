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
      defoverridable [get: 1, all: 0]
    end
  end
end
