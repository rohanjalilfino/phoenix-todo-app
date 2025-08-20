defmodule MyTodoWeb.TodoLive.Index do
  use MyTodoWeb, :live_view

  alias MyTodo.Todos

  @impl true
  def mount(_params, _session, socket) do
    todos = Todos.list_todos()
    {:ok, assign(socket, todos: todos)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    {:ok, _} = Todos.delete_todo(todo)

    new_todos = Enum.reject(socket.assigns.todos, fn t -> t.id == todo.id end)

    {:noreply, assign(socket, :todos, new_todos)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Todos
      <:actions>
        <.link href={~p"/todos/new"}>
          <.button>New Todo</.button>
        </.link>
      </:actions>
    </.header>

    <.table id="todos" rows={@todos} row_click={&JS.navigate(~p"/todos/#{&1}")}>
      <:col :let={todo} label="Title">{todo.title}</:col>
      <:col :let={todo} label="Done">{todo.done}</:col>
      <:action :let={todo}>
        <div class="sr-only">
          <.link navigate={~p"/todos/#{todo}"}>Show</.link>
        </div>
        <.link navigate={~p"/todos/#{todo}/edit"}>Edit</.link>
      </:action>
      <:action :let={todo}>
        <.link phx-click="delete" phx-value-id={todo.id} data-confirm="Are you sure?">
    Delete
    </.link>
      </:action>
    </.table>
    """
  end
end
