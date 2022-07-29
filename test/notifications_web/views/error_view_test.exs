defmodule NotificationsWeb.ErrorViewTest do
  use NotificationsWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(NotificationsWeb.ErrorView, "404.json", []) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(NotificationsWeb.ErrorView, "500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end

  test "should call template_not_found successfully" do
    result = NotificationsWeb.ErrorView.template_not_found("test.json", [])
    assert result == %{errors: %{detail: "Internal Server Error"}}
  end
end
