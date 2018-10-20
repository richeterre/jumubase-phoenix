defmodule JumubaseWeb.PerformanceController do
  use JumubaseWeb, :controller
  alias Ecto.Changeset
  alias Jumubase.Foundation
  alias Jumubase.Foundation.Contest
  alias Jumubase.Showtime
  alias Jumubase.Showtime.{Performance, Piece}

  # Pass contest from nested route to all actions
  def action(conn, _), do: get_contest!(conn, __MODULE__)

  def new(conn, _params, contest) do
    changeset =
      %Performance{pieces: [%Piece{}]}
      |> Showtime.change_performance()

    conn
    |> prepare_for_form(contest, changeset)
    |> render("new.html")
  end

  def create(conn, %{"performance" => params}, contest) do
    case Showtime.create_performance(contest, params) do
      {:ok, _} ->
        conn
        |> put_flash(:success, gettext("Success!"))
        |> redirect(to: page_path(conn, :home))
      {:error, changeset} ->
        conn
        |> prepare_for_form(contest, changeset)
        |> render("new.html")
    end
  end

  def edit(conn, %{"edit_code" => edit_code}, contest) do
    performance = Showtime.lookup_performance!(contest, edit_code)

    conn
    |> prepare_for_form(contest, Showtime.change_performance(performance))
    |> assign(:performance, performance)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "edit_code" => edit_code, "performance" => params}, contest) do
    params = normalize_params(params)

    performance = Showtime.get_performance!(contest, id, edit_code)
    case Showtime.update_performance(contest, performance, params) do
      {:ok, _} ->
        conn
        |> put_flash(:success, gettext("Edited successfully"))
        |> redirect(to: page_path(conn, :home))
      {:error, changeset} ->
        conn
        |> prepare_for_form(contest, changeset)
        |> assign(:performance, performance)
        |> render("edit.html")
    end
  end

  # Private helpers

  defp prepare_for_form(conn, %Contest{} = contest, %Changeset{} = changeset) do
    contest = Foundation.load_contest_categories(contest)

    contest_category_options = contest.contest_categories
    |> Enum.map(&{&1.category.name, &1.id, &1.category.type})

    conn
    |> assign(:contest, contest)
    |> assign(:contest_category_options, contest_category_options)
    |> assign(:changeset, changeset)
  end

  # Fills in empty associations if missing. This prevents such changes from
  # being ignored and enforces correct error handling of missing associations.
  defp normalize_params(params) do
    params
    |> Map.put_new("appearances", [])
    |> Map.put_new("pieces", [])
  end
end
