defmodule Jumubase.Seeder do
  @moduledoc """
  A tool for seeding data, e.g. from a console.
  """

  import Ecto.Query
  alias Jumubase.JumuParams
  alias Jumubase.Factory
  alias Jumubase.Foundation.{Category, Host}
  alias Jumubase.Repo

  @doc """
  Starts a seed for RW contests.
  """
  def start_rw_seed(season) do
    %{season: season, round: 1, contest_categories: []}
  end

  @doc """
  Starts a seed for Kimu contests.
  """
  def start_kimu_seed(season) do
    kimu_category = Repo.get_by!(Category, genre: "kimu")
    %{season: season, round: 0, contest_categories: [
      Factory.build(:contest_category,
        category: kimu_category,
        min_age_group: "Ia",
        max_age_group: "II",
        min_advancing_age_group: nil,
        max_advancing_age_group: nil
      )
    ]}
  end

  @doc """
  Adds a (contest) category to an RW seed by short name.
  The age group params are needed to complete the contest category.
  """
  def add_category(seed, short_name, min_ag, max_ag, min_adv_ag, max_adv_ag) do
    category = Repo.get_by!(Category, short_name: short_name)

    %{seed |
      contest_categories: seed.contest_categories ++
        [Factory.build(:contest_category,
          category: category,
          min_age_group: min_ag,
          max_age_group: max_ag,
          min_advancing_age_group: min_adv_ag,
          max_advancing_age_group: max_adv_ag
        )]
    }
  end

  @doc """
  Applies the seed for all hosts in the system.
  """
  def apply_for_all_hosts(seed) do
    apply_seed(seed, Repo.all(Host))
  end

  @doc """
  Applies the seed for the hosts with the given names.
  """
  def apply_for_hosts(seed, host_names) when is_list(host_names) do
    apply_seed(seed, Repo.all(from h in Host, where: h.name in ^host_names))
  end

  # Private helpers

  defp apply_seed(%{season: season, round: round, contest_categories: ccs}, hosts) do
    # Generate default dates
    year = JumuParams.year(season)
    {:ok, start_date} = Date.new(year, 1, 1)
    {:ok, end_date} = Date.new(year, 1, 1)
    {:ok, deadline} = Date.new(year - 1, 12, 15)

    for host <- hosts do
      Factory.insert(:contest, host: host, season: season, round: round,
        start_date: start_date, end_date: end_date, deadline: deadline,
        contest_categories: ccs
      )
    end
  end
end