defmodule NotificationsWeb.ErrorHelpersTest do
  ExUnit.start()

  use ExUnit.Case, async: true

  test "should call translate_error successfully" do
    result = NotificationsWeb.ErrorHelpers.translate_error({"error", %{reason: "any"}})
    assert result == "error"
  end
end
