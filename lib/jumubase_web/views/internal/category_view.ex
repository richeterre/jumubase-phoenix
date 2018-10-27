defmodule JumubaseWeb.Internal.CategoryView do
  use JumubaseWeb, :view
  alias Jumubase.JumuParams
  alias Jumubase.Foundation.Category

  @doc """
  Returns a textual tag describing the category's genre.
  """
  def genre_tag(%Category{genre: genre}) do
    content_tag(:span, genre_name(genre), class: "label label-default")
  end

  @doc """
  Returns a textual tag describing the category type.
  """
  def type_tag(%Category{type: type}) do
    content_tag(:span, type_name(type), class: "label label-default")
  end

  @doc """
  Returns a list of possible `genre` values suitable for forms.
  """
  def form_genres do
    Enum.map(JumuParams.genres(), &{genre_name(&1), &1})
  end

  @doc """
  Returns a list of possible `type` values suitable for forms.
  """
  def form_types do
    Enum.map(JumuParams.category_types(), &{type_name(&1), &1})
  end

  # Private helpers

  # Maps internal genres to user-facing genre names.
  defp genre_name(genre) do
    case genre do
      "classical" -> gettext("Classical")
      "popular" -> gettext("Popular")
      "kimu" -> gettext("Kimu")
    end
  end

  # Maps internal category types to user-facing category type names.
  defp type_name(type) do
    case type do
      "solo" -> gettext("Solo")
      "ensemble" -> gettext("Ensemble")
      "solo_or_ensemble" -> gettext("Solo/Ensemble")
    end
  end
end