defmodule Services.NotificationsServiceTest do
  ExUnit.start()

  use ExUnit.Case, async: true

  test "get_notifications success" do
    notification = %{hello: :world}

    repository = fn -> {:ok, notification} end
    notifications = Services.NotificationsService.get_notifications(repository)
    assert notifications == notification
  end

  test "get_notifications failure" do
    notification = %{hello: :world}

    repository = fn -> notification end
    func = fn -> Services.NotificationsService.get_notifications(repository) end
    assert_raise MatchError, func
  end

  test "insert_notifications success" do
    notification = %{hello: :world}

    repository = fn -> notification end
    notifications = Services.NotificationsService.insert_notifications(repository)
    assert notifications == notification
  end
end
