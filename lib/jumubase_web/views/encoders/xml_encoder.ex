defmodule JumubaseWeb.XMLEncoder do
  @moduledoc """
  A tool to export data as XML for use in other Jumu software,
  most notably JMDaten.
  """

  alias Jumubase.Showtime.{Appearance, Instruments, Performance}

  @doc """
  Encodes the list of performances to XML.
  """
  def encode(performances) do
    {:jumu, nil, Enum.map(performances, &to_xml/1)} |> XmlBuilder.generate
  end

  # Private helpers

  defp to_xml(%Performance{contest_category: cc} = performance) do
    [a1 | rest] = performance.appearances
    {:teilnehmer, %{id: a1.participant.id}, [
      to_xml(a1),
      {:wertung, nil, [
        {:type, nil, map_role(a1.role)},
        {:instrument_stimmlage, nil, Instruments.name(a1.instrument)},
        {:kategorie, nil, map_category(cc.category)},
      ]},
      {:spielpartner, nil, Enum.map(rest, &{:partner, %{id: &1.participant.id}, to_xml(&1)})}
    ]}
  end
  defp to_xml(%Appearance{participant: p} = a) do
    [
      {:vorname, nil, p.given_name},
      {:nachname, nil, p.family_name},
      {:geburtstag, nil, format_date(p.birthdate)},
      {:tel, nil, p.phone},
      {:email, nil, p.email},
      {:instrument, nil, Instruments.name(a.instrument)},
    ]
  end

  defp map_role("soloist"), do: "solo"
  defp map_role("ensemblist"), do: "gruppe"
  defp map_role("accompanist"), do: "begleiter"
  defp map_category(%{type: "solo"}), do: "A21"
  defp map_category(%{type: "ensemble"}), do: "B60"

  defp format_date(date), do: Timex.format!(date, "{D}.{M}.{YYYY}")
end
