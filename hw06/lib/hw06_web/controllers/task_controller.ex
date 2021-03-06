defmodule Hw06Web.TaskController do
  use Hw06Web, :controller

  alias Hw06.Tasks
  alias Hw06.Users
  alias Hw06.Tasks.Task

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    if (!conn.assigns[:current_user]) do
      conn
      |> put_flash(:error, "You need to be logged in to make a task")
      |> redirect(to: Routes.user_path(conn, :index))
      |> halt
    end

    changeset = Tasks.change_task(%Task{
      completed: false,
      time_spent: 0,
      user_id: conn.assigns[:current_user].id,
    })
    users = Users.list_user_emails
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        users = Users.list_user_emails
        render(conn, "new.html", changeset: changeset, users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    if (!conn.assigns[:current_user]) do
      conn
      |> put_flash(:error, "You need to be logged in to edit a task")
      |> redirect(to: Routes.user_path(conn, :index))
      |> halt
    end

    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    users = Users.list_user_emails
    render(conn, "edit.html", task: task, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    case Tasks.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    if (!conn.assigns[:current_user]) do
      conn
      |> put_flash(:error, "You need to be logged in to delete a task")
      |> redirect(to: Routes.user_path(conn, :index))
      |> halt
    end

    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
