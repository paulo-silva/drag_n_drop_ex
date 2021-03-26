defmodule DragNDropExWeb.Components.Drag.DropZone do
  @moduledoc """
  DropZone for drag n' drop component to be used on pages.

  Usage:
  1. Define drop_zone attributes including title, drop_zone_id and draggable items, e.g.:
    drop_zone_attributes = [
      title: "Drop zone 1",
      drop_zone_id: "drop_zone_1",
      draggables: [
        %{id: "item_1", text: "Item 1"},
        %{id: "item_2", text: "Item 2"},
        %{id: "item_3", text: "Item 3"}
      ],
      class: "mr-2" # => optional custom style
    ]

  2. Load DropZone component with attributes in html:
    <%= live_component(@socket, DropZone, drop_zone_attributes) %>

  3. Handle the drop event that is fired every time an item is moved:
    def handle_event("drop", %{
          "dragged_id" => dragged_id, # moved item id
          "dropzone_id" => drop_zone_id, # dropzone that item is now located
          "draggable_index" => draggable_index # index that the item is moved to
        }, socket) do
      # Make logic to update the items and show it.
    end
  """

  use DragNDropExWeb, :live_component

  @impl Phoenix.LiveComponent
  def mount(socket) do
    {:ok, assign(socket, default_assigns())}
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~L"""
      <div class="w-1/2 mx-3 flex flex-col pb-5">
        <span class="text-black mb-3 font-medium text-base"><%= @title %></span>
        <div class="<%= @class %> <%= highlight_classes(@highlight) %>" id="<%= @drop_zone_id %>">
          <%= if Enum.any?(@draggables) do %>
            <%= for %{draggable: draggable, id: id} <- @draggables do %>
              <div draggable="true" id="<%= id %>" class="flex items-center draggable cursor-move mb-2">
                <%= render_block(@inner_block, draggable: draggable) %>
                <%= icon_tag(@socket, "hamburger", class: "w-4 h-4") %>
              </div>
            <% end %>
          <% else %>
            <%= if @highlight do %>
              <p class="-ml-4 -mt-4 absolute flex justify-center items-center h-full w-full text-center text-gray-500 text-blue-600">
                Drop Here
              </p>
            <% else %>
              <p class="-ml-4 -mt-4 absolute flex justify-center items-center h-full w-full text-center text-gray-500">
                No items yet
              </p>
            <% end %>
          <% end %>
        </div>
      </div>
    """
  end

  defp default_assigns do
    [
      highlight: false,
      class: "relative flex flex-col h-full bg-gray-100 dropzone p-4 rounded-md last:mb-0"
    ]
  end

  def highlight_classes(true), do: "border-2 border-blue-500"
  def highlight_classes(false), do: ""
end
