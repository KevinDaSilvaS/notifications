defmodule NotificationsWeb.Helpers.SetPaginationTest do
  ExUnit.start()
  use ExUnit.Case, async: true

  test "should set page and limit passed as parameters" do
    opts = %{"limit" => "2", "page" => "1"}
    result = NotificationsWeb.Helpers.SetPagination.set(opts)

    assert result == {2, 1}
  end

  test "should set page and limit as default values" do
    opts = %{}
    result = NotificationsWeb.Helpers.SetPagination.set(opts)

    assert result == {10, 1}
  end
end
