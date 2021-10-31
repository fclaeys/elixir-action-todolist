defmodule TodoServerTest do
  use ExUnit.Case

  test "todo_server_proccess" do
    server_pid = Todo.Server.start("test list")
  end

  test "todo-operations" do
    {:ok, server_pid} = Todo.Server.start("test list")
    assert [] == Todo.Server.entries(server_pid, ~D[2021-10-24])

    Todo.Server.add_entry(server_pid, %{date: ~D[2021-10-24], title: "first"})

    assert [%{date: ~D[2021-10-24], id: 1, title: "first"}] ==
             Todo.Server.entries(server_pid, ~D[2021-10-24])

    Todo.Server.update_entry(server_pid, %{date: ~D[2021-10-24], title: "first modified", id: 1})

    assert [%{date: ~D[2021-10-24], id: 1, title: "first modified"}] ==
             Todo.Server.entries(server_pid, ~D[2021-10-24])

    Todo.Server.delete_entry(server_pid, 1)
    assert [] == Todo.Server.entries(server_pid, ~D[2021-10-24])
  end
end
