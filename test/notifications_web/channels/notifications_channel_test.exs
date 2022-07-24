defmodule NotificationsWeb.NotificationsChannelTest do
  use NotificationsWeb.ChannelCase

  @config Application.fetch_env!(:notifications, NotificationsWeb.NotificationsChannel)
  @broadcasting_key Keyword.get(@config, :broadcasting_key)

  setup do
    {:ok, _, socket} =
      NotificationsWeb.NotificationsSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(NotificationsWeb.NotificationsChannel, "notifications:lobby")

    %{socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to notifications:lobby when broadcasting key is set", %{socket: socket} do
    body = %{
        "topic" => "lobby",
        "title" => "a notification title",
        "message" => "a notification message",
        "redirect" => "myapp.com/stuff-on-sale"
    }
    push(socket, "shout", %{"body" => body, "broadcasting_key" => @broadcasting_key})
    assert_broadcast "shout", ^body
  end

  test "shouldnt shout broadcasts to notifications:lobby when broadcasting key is not set", %{socket: socket} do
    body = %{
        "topic" => "lobby",
        "title" => "a notification title",
        "message" => "a notification message",
        "redirect" => "myapp.com/stuff-on-sale"
    }
    push(socket, "shout", %{"body" => body})
    refute_broadcast "shout", ^body
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end
end
