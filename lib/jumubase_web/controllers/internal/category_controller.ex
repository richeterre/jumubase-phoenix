defmodule JumubaseWeb.Internal.CategoryController do
  use JumubaseWeb, :controller
  alias Jumubase.Repo
  alias Jumubase.Foundation
  alias Jumubase.Foundation.Category

  plug :add_breadcrumb, icon: "home", path_fun: &internal_page_path/2, action: :home
  plug :add_breadcrumb, name: gettext("Categories"), path_fun: &internal_category_path/2, action: :index

  plug :role_check, roles: ["admin"]

  def index(conn, _params) do
    render(conn, "index.html", categories: Foundation.list_categories())
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Category.changeset(%Category{}, %{}))
    |> add_breadcrumb(icon: "plus", path: internal_category_path(conn, :new))
    |> render("new.html")
  end

  def create(conn, %{"category" => category_params}) do
    changeset = Category.changeset(%Category{}, category_params)

    case Repo.insert(changeset) do
      {:ok, category} ->
        conn
        |> put_flash(:success,
          gettext("The category \"%{name}\" was created.", name: category.name))
        |> redirect(to: internal_category_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end
end
