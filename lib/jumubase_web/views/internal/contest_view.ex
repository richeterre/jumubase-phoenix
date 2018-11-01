defmodule JumubaseWeb.Internal.ContestView do
  use JumubaseWeb, :view
  alias Jumubase.JumuParams
  alias Jumubase.Foundation.Contest

  @doc """
  Returns a display name for the given contest.
  """
  def name(%Contest{} = contest) do
    round_name = short_round_name(contest.round)
    contest_year = JumuParams.year(contest.season)
    "#{contest.host.name}, #{round_name} #{contest_year}"
  end

  def name_with_flag(%Contest{} = contest) do
    flag_code = case contest.round do
      2 -> "EU"
      _ -> contest.host.country_code
    end
    "#{emoji_flag(flag_code)} #{name(contest)}"
  end

  @doc """
  Returns formatted deadline info in case the contest's deadline
  doesn't match the general deadline.
  """
  def deadline_info(%Contest{deadline: deadline}, general_deadline) do
    case deadline do
      ^general_deadline ->
        nil
      _ ->
        deadline_tag = content_tag(:strong, format_date(deadline, :medium))
        "(#{gettext("Deadline")}: #{safe_to_string(deadline_tag)})" |> raw
    end
  end

  @doc """
  Returns the given contest's date(s) in a formatted way.
  """
  def dates(%Contest{start_date: sd, end_date: ed}) do
    cond do
      sd == ed ->
        format_date(sd)
      true ->
        "#{format_date(sd)} – #{format_date(ed)}"
    end
  end

  @doc """
  Formats the given date for display.
  """
  def format_date(date, style \\ :full)
  def format_date(%Date{} = date, style) do
    locale = Timex.Translator.current_locale
    Timex.lformat!(date, date_format(locale, style), locale)
  end
  def format_date(nil, _style), do: nil

  # Private helpers

  defp short_round_name(round) do
    case round do
      0 -> "Kimu"
      1 -> "RW"
      2 -> "LW"
      3 -> "BW"
    end
  end

  # Returns a date format for the locale.
  defp date_format("de", :full), do: "{D}. {Mfull} {YYYY}"
  defp date_format("de", :medium), do: "{D}. {Mfull}"
  defp date_format("en", :full), do: "{D} {Mfull} {YYYY}"
  defp date_format("en", :medium), do: "{D} {Mfull}"
end
