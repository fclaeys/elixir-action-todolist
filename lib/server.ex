defmodule Todo.Server do
  use GenServer

  # start
  def start_link(name) do
    IO.puts("Demarrage de la todo liste #{name}")

    GenServer.start_link(
      __MODULE__,
      name,
      name: via_tuple(name)
    )
  end

  defp via_tuple(name) do
    Todo.Registry.via_tuple({__MODULE__, name})
  end

  def whereis(name) do
    Todo.Registry.whereis_name({__MODULE__, name})
  end

  # exposer une api, ici ajouter, modifier, supprimer une tache
  # recuperer une liste de tache pouur une date
  def add_entry(todo_server, new_entry) do
    IO.puts("Ajoute une todo")
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def update_entry(todo_server, %{} = new_entry) do
    IO.puts("Met a jour un todo")
    GenServer.cast(todo_server, {:update_entry, new_entry})
  end

  def delete_entry(todo_server, entry_id) do
    IO.puts("Supprime un todo")
    GenServer.cast(todo_server, {:delete_entry, entry_id})
  end

  def entries(todo_server, date) do
    IO.puts("Recupere une liste de todo")
    GenServer.call(todo_server, {:entries, date})
  end

  @impl true
  def init(name) do
    IO.puts("Init de la liste #{name}")
    {:ok, {name, Todo.Database.get(name) || Todo.List.new()}}
  end

  # implementer les handlers (call et cast) pour faire le job
  @impl true
  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl true
  def handle_cast({:update_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl true
  def handle_cast({:delete_entry, entry_id}, {name, todo_list}) do
    new_list = Todo.List.delete_entry(todo_list, entry_id)

    {:noreply, {name, new_list}}
  end

  @impl true
  def handle_call({:entries, date}, _, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), {name, todo_list}}
  end
end
