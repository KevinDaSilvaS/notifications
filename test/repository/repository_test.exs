defmodule Repository.NotificationsTest do
  ExUnit.start()

  use ExUnit.Case, async: true

  test "should get notifications successfully" do
    {status, payload} = Repository.Notifications.find_notifications([], %{}, [], 10, 1)

    assert status == :ok
    assert is_list(payload)
  end

  test "should insert many notifications successfully" do
    {status, payload} = Repository.Notifications.insert_notifications([])

    assert status == :ok
    assert is_list(payload)
  end
end
