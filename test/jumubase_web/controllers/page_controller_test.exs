defmodule JumubaseWeb.PageControllerTest do
  use JumubaseWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Jumu Nordost"
  end
end
