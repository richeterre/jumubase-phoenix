defmodule JumubaseWeb.Internal.UserView do
  use JumubaseWeb, :view
  import JumubaseWeb.Internal.HostView, only: [name_with_flag: 1]
  alias Jumubase.JumuParams

  @doc """
  Returns the given user's full name.
  """
  def full_name(user) do
    "#{user.given_name} #{user.family_name}"
  end

  @doc """
  Returns the user's associated hosts as Emoji flags.
  """
  def host_flags(user) do
    user.hosts |> Enum.map(&name_with_flag/1)
  end

  @doc """
  Returns the names of the user's associated hosts.
  """
  def host_names(user) do
    user.hosts
    |> Enum.map(& &1.name)
    |> Enum.join(", ")
  end

  @doc """
  Returns a textual tag describing the user's role.
  """
  def role_tag(role) do
    case role do
      "local-organizer" ->
        nil

      _ ->
        text = role_name(role)
        content_tag(:span, text, class: "label label-#{label_class(role)}")
    end
  end

  @doc """
  Returns a list of possible `role` values suitable for forms.
  """
  def form_roles do
    Enum.map(JumuParams.user_roles(), &{role_name(&1), &1})
  end

  # Maps internal roles to user-facing role names.
  defp role_name(role) do
    case role do
      "admin" -> gettext("Admin")
      "observer" -> gettext("Observer")
      "global-organizer" -> gettext("Global Organizer")
      "local-organizer" -> gettext("Local Organizer")
    end
  end

  # Maps roles to classes that determine label style.
  defp label_class(role) do
    case role do
      "admin" -> "danger"
      "observer" -> "info"
      "global-organizer" -> "warning"
      _ -> "default"
    end
  end
end
