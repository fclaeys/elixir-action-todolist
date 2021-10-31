defmodule Todo.Registry do
  def start_link() do
    IO.puts("Starting todo server registry")
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def child_spec(_) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end

  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  def whereis_name(key) do
    Registry.whereis_name({__MODULE__, key})
  end
end
