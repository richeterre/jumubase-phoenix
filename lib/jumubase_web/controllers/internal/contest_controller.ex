defmodule JumubaseWeb.Internal.ContestController do
  use JumubaseWeb, :controller
  alias Jumubase.Foundation

  plug :add_breadcrumb, icon: "home", path_fun: &internal_page_path/2, action: :home
  plug :add_breadcrumb, name: gettext("Contests"), path_fun: &internal_contest_path/2, action: :index

  plug :role_check, roles: ["admin"]

  def index(conn, _params) do
    conn
    |> assign(:contests, Foundation.list_contests())
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    contest =
      Foundation.get_contest!(id)
      |> Foundation.load_contest_categories

    conn
    |> assign(:contest, contest)
    |> add_contest_breadcrumb(contest)
    |> render("show.html")
  end
end
