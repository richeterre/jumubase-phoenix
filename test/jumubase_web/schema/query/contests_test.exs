defmodule JumubaseWeb.Schema.Query.ContestsTest do
  use JumubaseWeb.ConnCase, async: true

  test "returns all contests with public timetables", %{conn: conn} do
    %{stages: [s]} = h = insert(:host, stages: build_list(1, :stage))
    [c1, c2] = insert_list(2, :contest, host: h, timetables_public: true)
    [c3, c4] = insert_list(2, :contest, host: h, timetables_public: false)

    insert_performance(c1, stage: s)
    insert_performance(c2, stage: s)
    insert_performance(c3, stage: s)
    insert_performance(c4, stage: s)

    query = "query { contests { id } }"
    conn = get(conn, "/graphql", query: query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "contests" => [
                 %{"id" => "#{c1.id}"},
                 %{"id" => "#{c2.id}"}
               ]
             }
           }
  end

  test "returns all contest fields", %{conn: conn} do
    %{stages: [s]} =
      h =
      insert(:host,
        name: "DS Helsinki",
        country_code: "FI",
        stages: [build(:stage, name: "Aula")]
      )

    c =
      insert(:contest,
        host: h,
        season: 56,
        round: 1,
        start_date: ~D[2019-01-01],
        end_date: ~D[2019-01-03],
        timetables_public: true
      )

    insert_performance(c, stage: s)

    query = """
    query {
      contests { id name countryCode startDate endDate dates stages { id name } }
    }
    """

    conn = get(conn, "/graphql", query: query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "contests" => [
                 %{
                   "id" => "#{c.id}",
                   "name" => "DS Helsinki, RW 2019",
                   "countryCode" => "FI",
                   "startDate" => "2019-01-01",
                   "endDate" => "2019-01-03",
                   "dates" => ["2019-01-01", "2019-01-02", "2019-01-03"],
                   "stages" => [
                     %{"id" => "#{s.id}", "name" => "Aula"}
                   ]
                 }
               ]
             }
           }
  end
end
