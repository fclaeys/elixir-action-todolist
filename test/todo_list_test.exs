defmodule TodoListTest do
  use ExUnit.Case

  test "empty_list" do
    assert Todo.List.size(Todo.List.new()) == 0
  end

  test "entries" do
    todo_list =
      Todo.List.new([
        %{date: ~D[2021-10-23], title: "Write tests"},
        %{date: ~D[2021-10-24], title: "Sleep"},
        %{date: ~D[2021-10-23], title: "Do some stuff"}
      ])

    assert Todo.List.size(todo_list) == 3
    assert Todo.List.entries(todo_list, ~D[2021-10-23]) |> length() == 2
    assert Todo.List.entries(todo_list, ~D[2021-10-24]) |> length() == 1
    assert Todo.List.entries(todo_list, ~D[2021-10-25]) |> length() == 0

    titles = assert Todo.List.entries(todo_list, ~D[2021-10-23]) |> Enum.map(& &1.title)
    assert ["Write tests", "Do some stuff"] == titles
  end

  test "add_entry" do
    todo_list =
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2021-10-23], title: "Write tests"})
      |> Todo.List.add_entry(%{date: ~D[2021-10-24], title: "Sleep"})
      |> Todo.List.add_entry(%{date: ~D[2021-10-23], title: "Do some stuff"})

    assert Todo.List.size(todo_list) == 3
    assert Todo.List.entries(todo_list, ~D[2021-10-23]) |> length() == 2
    assert Todo.List.entries(todo_list, ~D[2021-10-24]) |> length() == 1
    assert Todo.List.entries(todo_list, ~D[2021-10-25]) |> length() == 0

    titles = assert Todo.List.entries(todo_list, ~D[2021-10-23]) |> Enum.map(& &1.title)
    assert ["Write tests", "Do some stuff"] == titles
  end

  test "update_entry" do
    todo_list =
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2021-10-23], title: "Write tests"})
      |> Todo.List.add_entry(%{date: ~D[2021-10-24], title: "Sleep"})
      |> Todo.List.add_entry(%{date: ~D[2021-10-23], title: "Do some stuff"})
      |> Todo.List.update_entry(2, &Map.put(&1, :title, "updated title"))

    assert Todo.List.size(todo_list) == 3
    assert Todo.List.entries(todo_list, ~D[2021-10-23]) |> length() == 2
    assert Todo.List.entries(todo_list, ~D[2021-10-24]) |> length() == 1
    assert Todo.List.entries(todo_list, ~D[2021-10-25]) |> length() == 0

    titles = assert Todo.List.entries(todo_list, ~D[2021-10-24]) |> Enum.map(& &1.title)
    assert ["updated title"] == titles
  end

  test "delete_entry" do
    todo_list =
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2021-10-23], title: "Write tests"})
      |> Todo.List.add_entry(%{date: ~D[2021-10-24], title: "Sleep"})
      |> Todo.List.add_entry(%{date: ~D[2021-10-23], title: "Do some stuff"})
      |> Todo.List.delete_entry(2)

    assert Todo.List.size(todo_list) == 2
    assert Todo.List.entries(todo_list, ~D[2021-10-23]) |> length() == 2
    assert Todo.List.entries(todo_list, ~D[2021-10-24]) |> length() == 0
    assert Todo.List.entries(todo_list, ~D[2021-10-25]) |> length() == 0

    titles = assert Todo.List.entries(todo_list, ~D[2021-10-23]) |> Enum.map(& &1.title)
    assert ["Write tests", "Do some stuff"] == titles
  end
end
