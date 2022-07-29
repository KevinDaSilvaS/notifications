defmodule TelemetryTest do
  ExUnit.start()

  use ExUnit.Case, async: true

  test "should get metrics successfully" do
    result = NotificationsWeb.Telemetry.metrics()
    assert is_list(result)
  end
end
