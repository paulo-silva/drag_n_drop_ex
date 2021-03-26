defmodule DragNDropExWeb.Helpers.Icon do
  @moduledoc """
  Helper functions that can be used in views.
  """

  use Phoenix.HTML
  alias DragNDropExWeb.Router.Helpers, as: Routes

  @doc """
  Prints a svg icon based on the give `name`.

  Returns `<svg>`.

  ## Examples
      iex> DragNDropExWeb.Helpers.Icon.icon_tag(@socket, "sports", class: "mb-3")
      "<svg id="sports">...</svg>"
  """
  def icon_tag(conn, name, opts \\ []) do
    content_tag(:svg, opts) do
      tag(:use, href: "#{Routes.static_path(conn, "/images/icons.svg")}##{name}")
    end
  end
end
