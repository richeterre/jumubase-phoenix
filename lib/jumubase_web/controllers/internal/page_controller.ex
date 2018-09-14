defmodule JumubaseWeb.Internal.PageController do
  use JumubaseWeb, :controller
  import JumubaseWeb.Authorize

  plug :add_breadcrumb, icon: "home", path_fun: &internal_page_path/2, action: :home

  plug :user_check

  def home(%Plug.Conn{assigns: %{current_user: user}} = conn, _params) do
    render(conn, "home.html", current_user: user, contests: [])
  end
end
