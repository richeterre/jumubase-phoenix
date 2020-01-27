NimbleCSV.define(CSVParser, separator: "\t", escape: "\"")

defmodule JumubaseWeb.CSVEncoder do
  @moduledoc """
  A tool to export registration data as comma-separated values.
  """

  import JumubaseWeb.Internal.PerformanceView, only: [category_name: 1]
  alias Jumubase.Showtime.{Participant, Performance}

  def encode(participants) do
    data = column_headers() ++ Enum.map(participants, &map_participant/1)

    data
    |> CSVParser.dump_to_iodata()
    |> make_ms_excel_compatible
  end

  # Private helpers

  defp column_headers do
    [~w(Nachname Vorname Geburtsdatum Telefon E-Mail Auftritte)]
  end

  defp map_participant(%Participant{} = pt) do
    [
      pt.family_name,
      pt.given_name,
      Timex.format!(pt.birthdate, "{0D}.{0M}.{YYYY}"),
      pt.phone,
      pt.email,
      Enum.map(pt.performances, &format_performance/1) |> Enum.join(", ")
    ]
  end

  defp format_performance(%Performance{} = p) do
    "#{category_name(p)} #{p.age_group}"
  end

  defp make_ms_excel_compatible(data) do
    # See https://underthehood.meltwater.com/blog/2018/08/08/excel-friendly-csv-exports-with-elixir/ for details
    encoding = {:utf16, :little}
    bom = :unicode.encoding_to_bom(encoding)
    converted_data = :unicode.characters_to_binary(data, :utf8, encoding)
    [bom, converted_data]
  end
end
