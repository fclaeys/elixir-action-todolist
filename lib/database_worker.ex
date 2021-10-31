defmodule Todo.DatabaseWorker do
  use GenServer

  def start_link({db_folder, worker_id}) do
    IO.puts("Startiing database worker #{worker_id} on folder #{db_folder}")
    GenServer.start_link(__MODULE__, db_folder, name: via_tuple(worker_id))
  end

  def via_tuple(worker_id) do
    Todo.Registry.via_tuple({__MODULE__, worker_id})
  end

  def store(worker_id, key, data) do
    GenServer.cast(via_tuple(worker_id), {:store, key, data})
  end

  def get(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get, key})
  end

  def delete(worker_id, key) do
    GenServer.cast(via_tuple(worker_id), {:delete, key})
  end

  @impl GenServer
  def init(db_folder) do
    {:ok, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    db_folder
    |> file_name(key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  @impl GenServer
  def handle_cast({:delete, key}, db_folder) do
    db_folder
    |> file_name(key)
    |> File.rm!()

    {:noreply, db_folder}
  end

  @impl GenServer
  def handle_call({:get, key}, _, db_folder) do
    data =
      case File.read(file_name(db_folder, key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

    {:reply, data, db_folder}
  end

  defp file_name(db_folder, key) do
    Path.join(db_folder, to_string(key))
  end
end
