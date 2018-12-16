defmodule JumubaseWeb.Internal.StageViewTest do
  use JumubaseWeb.ConnCase, async: true
  alias JumubaseWeb.Internal.StageView

  describe "schedule_minutes/1" do
    test "rounds the performance's duration to the nearest 5-minute multiple" do
      p1 = build(:performance, pieces: [build(:piece, minutes: 10, seconds: 0)])
      p2 = build(:performance, pieces: [build(:piece, minutes: 10, seconds: 1)])
      assert StageView.schedule_minutes(p1) == 10
      assert StageView.schedule_minutes(p2) == 15
    end
  end

  describe "item_height/1" do
    test "converts the performance's duration to the right pixel amount" do
      p1 = build(:performance, pieces: [build(:piece, minutes: 10, seconds: 0)])
      p2 = build(:performance, pieces: [build(:piece, minutes: 10, seconds: 1)])
      assert StageView.item_height(p1) == "40px"
      assert StageView.item_height(p2) == "60px"
    end
  end

  describe "playtime_percentage/1" do
    test "returns what percentage of the performance's schedule minutes is taken up by playtime" do
      p1 = build(:performance, pieces: [build(:piece, minutes: 12, seconds: 0)])
      p2 = build(:performance, pieces: [build(:piece, minutes: 15, seconds: 0)])
      assert StageView.playtime_percentage(p1) == "80.0%"
      assert StageView.playtime_percentage(p2) == "100.0%"
    end
  end
end
