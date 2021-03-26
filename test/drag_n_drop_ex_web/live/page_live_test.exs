defmodule DragNDropExWeb.PageLiveTest do
  use DragNDropExWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "drag n' drop" do
    test "can add a drag from b to a", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))

      assert view
             |> element("#Drag")
             |> render_hook(:dropped, %{
               "dragged_id" => "drag-me-b-0",
               "dropzone_id" => "drop_zone_a",
               "draggable_index" => 1
             })

      assert has_element?(view, "div#drop_zone_a > div[draggable]", "Drag Me B-0")
      refute has_element?(view, "div#drop_zone_b > div[draggable]", "Drag Me B-0")
    end

    test "can add a drag from a to b", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))

      assert view
             |> element("#Drag")
             |> render_hook(:dropped, %{
               "dragged_id" => "drag-me-a-0",
               "dropzone_id" => "drop_zone_b",
               "draggable_index" => 1
             })

      refute has_element?(view, "div#drop_zone_a > div[draggable]", "Drag Me A-0")
      assert has_element?(view, "div#drop_zone_b > div[draggable]", "Drag Me A-0")
    end

    test "can add/remove multiple times", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))

      assert view
             |> element("#Drag")
             |> render_hook(:dropped, %{
               "dragged_id" => "drag-me-a-0",
               "dropzone_id" => "drop_zone_b",
               "draggable_index" => 1
             })

      refute has_element?(view, "div#drop_zone_a > div[draggable]", "Drag Me A-0")
      assert has_element?(view, "div#drop_zone_b > div[draggable]", "Drag Me A-0")

      assert view
             |> element("#Drag")
             |> render_hook(:dropped, %{
               "dragged_id" => "drag-me-a-0",
               "dropzone_id" => "drop_zone_a",
               "draggable_index" => 1
             })

      assert has_element?(view, "div#drop_zone_a > div[draggable]", "Drag Me A-0")
      refute has_element?(view, "div#drop_zone_b > div[draggable]", "Drag Me A-0")
    end
  end
end
