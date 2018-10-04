defmodule JumubaseWeb.Internal.ParticipantViewTest do
  use JumubaseWeb.ConnCase, async: true
  alias JumubaseWeb.Internal.ParticipantView

  test "full_name/1 returns a participant's full name" do
    participant = build(:participant, given_name: "A", family_name: "B")
    assert ParticipantView.full_name(participant) == "A B"
  end

  test "birthdate/1 returns a participant's formatted birthdate" do
    participant = build(:participant, birthdate: ~D[2004-01-01])
    assert ParticipantView.birthdate(participant) == "2004-01-01"
  end
end
