defmodule Todo.Cache do
  use GenServer

  def start_link(_) do
    IO.puts("Startinig Todo Cache")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  # Public api
  def get_todo_list(name) do
    GenServer.call(__MODULE__, {:get_todo_list, name})
  end

  # GenServer impl
  @impl GenServer
  def handle_call({:get_todo_list, name}, _, state) do
    result = Todo.Server.start_link(name)

    case result do
      {:ok, todo_server} ->
        {:reply, todo_server, state}

      {:error, {:already_started, todo_server}} ->
        {:reply, todo_server, state}
    end
  end
end
