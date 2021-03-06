defmodule Jumubase.Showtime.Appearance do
  use Jumubase.Schema
  import Ecto.Changeset
  import Jumubase.Gettext
  alias Ecto.Changeset
  alias Jumubase.JumuParams
  alias Jumubase.Showtime.{Appearance, Participant, Performance}

  schema "appearances" do
    field :instrument, :string
    field :role, :string
    field :age_group, :string
    field :points, :integer

    belongs_to :performance, Performance
    belongs_to :participant, Participant, on_replace: :delete

    timestamps()
  end

  @required_attrs [:role, :instrument]

  @doc false
  def changeset(%Appearance{} = appearance, attrs) do
    appearance
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
    |> validate_inclusion(:role, JumuParams.participant_roles())
    |> cast_assoc(:participant, required: true)
    |> preserve_participant_identity()
    |> unique_constraint(:participant,
      name: :no_multiple_appearances,
      message: dgettext("errors", "can only appear once in a performance")
    )
  end

  @doc """
  Allows setting a result for the given appearance.
  """
  def result_changeset(%Appearance{} = appearance, points) do
    appearance
    |> cast(%{points: points}, [:points])
    |> validate_inclusion(:points, JumuParams.points())
  end

  @doc """
  Allows migrating the appearance by clearing its round-specific data.
  """
  def migration_changeset(%Appearance{} = a) do
    %Appearance{instrument: a.instrument, role: a.role, age_group: a.age_group}
    |> Changeset.change(points: nil)
    |> Changeset.put_assoc(:participant, a.participant)
  end

  def soloist?(%Appearance{role: role}), do: role == "soloist"

  def ensemblist?(%Appearance{role: role}), do: role == "ensemblist"

  def accompanist?(%Appearance{role: role}), do: role == "accompanist"

  def has_points?(%Appearance{points: points}), do: points != nil

  # Private helpers

  # Preserves the participant's identity when updating a nested participant.
  defp preserve_participant_identity(%Changeset{} = changeset) do
    with %Changeset{changes: %{participant: %{action: :update} = pt_cs}} <- changeset,
         true <- Participant.has_identity_changes?(pt_cs) do
      add_error(
        changeset,
        :participant,
        dgettext(
          "errors",
          "To change the name or birthdate, please remove and add back this person."
        )
      )
    else
      _ ->
        changeset
    end
  end
end
