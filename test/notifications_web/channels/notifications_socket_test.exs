defmodule NotificationsWeb.NotificationsSocketTest do
  ExUnit.start()

  use ExUnit.Case, async: true

  test "should call connect successfully" do
    connectionResult = NotificationsWeb.NotificationsSocket.connect([], :socket, [])
    assert connectionResult == {:ok, :socket}
  end

  test "should call id successfully" do
    result = NotificationsWeb.NotificationsSocket.id(:socket)
    assert result == nil
  end
end
