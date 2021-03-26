defmodule DragNDropExWeb.PageLive do
  @moduledoc false

  use DragNDropExWeb, :live_view

  alias DragNDropExWeb.Components.Drag.DropZone

  @dropzones [:drop_zone_a, :drop_zone_b]

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:drop_zone_a, draggables(1))
      |> assign(:drop_zone_b, draggables(2))
      |> assign(:highlight_dropzone, "")

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "dropped",
        %{
          "dragged_id" => dragged_id,
          "dropzone_id" => drop_zone_id,
          "draggable_index" => draggable_index
        },
        %{assigns: assigns} = socket
      ) do
    if valid_drop_zone?(drop_zone_id) do
      drop_zone_atom = String.to_existing_atom(drop_zone_id)
      dragged = find_dragged(assigns, dragged_id)

      socket =
        Enum.reduce(@dropzones, socket, fn zone_atom, %{assigns: assigns} = accumulator ->
          updated_list = update_list(assigns, zone_atom, dragged, drop_zone_atom, draggable_index)

          assign(accumulator, zone_atom, updated_list)
        end)

      {:noreply, remove_highlight(socket)}
    else
      throw("invalid drop_zone_id")

      {:noreply, put_flash(socket, :error, "invalid drop zone!")}
    end
  end

  def handle_event("dragged", %{"dropzone_id" => "drop_zone_a"}, socket) do
    {:noreply, assign(socket, :highlight_dropzone, "drop_zone_b")}
  end

  def handle_event("dragged", %{"dropzone_id" => "drop_zone_b"}, socket) do
    {:noreply, assign(socket, :highlight_dropzone, "drop_zone_a")}
  end

  defp draggables(1) do
    [
      %{id: "drag-me-a-0", draggable: "Drag Me A-0"},
      %{id: "drag-me-a-1", draggable: "Drag Me A-1"},
      %{id: "drag-me-a-2", draggable: "Drag Me A-2"},
      %{id: "drag-me-a-3", draggable: "Drag Me A-3"}
    ]
  end

  defp draggables(2) do
    [
      %{id: "drag-me-b-0", draggable: "Drag Me B-0"},
      %{id: "drag-me-b-1", draggable: "Drag Me B-1"},
      %{id: "drag-me-b-2", draggable: "Drag Me B-2"},
      %{id: "drag-me-b-3", draggable: "Drag Me B-3"}
    ]
  end

  defp valid_drop_zone?(drop_zone_id), do: drop_zone_id in Enum.map(@dropzones, &to_string/1)

  defp find_dragged(%{drop_zone_a: drop_zone_a, drop_zone_b: drop_zone_b}, dragged_id) do
    Enum.find(drop_zone_a ++ drop_zone_b, &(&1.id == dragged_id))
  end

  defp update_list(assigns, list_atom, dragged, drop_zone_atom, draggable_index)
       when list_atom == drop_zone_atom do
    assigns[list_atom]
    |> remove_dragged(dragged.id)
    |> List.insert_at(draggable_index, dragged)
  end

  defp update_list(assigns, list_atom, dragged, drop_zone_atom, _draggable_index)
       when list_atom != drop_zone_atom,
       do: remove_dragged(assigns[list_atom], dragged.id)

  defp remove_dragged(list, dragged_id),
    do: Enum.filter(list, fn draggable -> draggable.id != dragged_id end)

  defp remove_highlight(socket) do
    assign(socket, :highlight_dropzone, "")
  end
end
