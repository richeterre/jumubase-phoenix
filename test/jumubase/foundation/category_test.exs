defmodule Jumubase.CategoryTest do
  use Jumubase.DataCase
  alias Jumubase.Foundation.Category

  describe "changeset" do
    test "with valid attributes" do
      params = params_for(:category)
      changeset = Category.changeset(%Category{}, params)
      assert changeset.valid?
    end

    test "without a name" do
      params = params_for(:category, name: "")
      changeset = Category.changeset(%Category{}, params)
      refute changeset.valid?
    end

    test "without a short name" do
      params = params_for(:category, short_name: "")
      changeset = Category.changeset(%Category{}, params)
      refute changeset.valid?
    end

    test "without a genre" do
      params = params_for(:category, genre: nil)
      changeset = Category.changeset(%Category{}, params)
      refute changeset.valid?
    end

    test "with an invalid genre" do
      for genre <- ["", "xyz"] do
        params = params_for(:category, genre: genre)
        changeset = Category.changeset(%Category{}, params)
        refute changeset.valid?
      end
    end

    test "without a type" do
      params = params_for(:category, type: nil)
      changeset = Category.changeset(%Category{}, params)
      refute changeset.valid?
    end

    test "with an invalid type" do
      for type <- ["", "xyz"] do
        params = params_for(:category, type: type)
        changeset = Category.changeset(%Category{}, params)
        refute changeset.valid?
      end
    end
  end
end
