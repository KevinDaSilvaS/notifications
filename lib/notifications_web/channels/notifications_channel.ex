defmodule NotificationsWeb.NotificationsChannel do
  use NotificationsWeb, :channel

  @config Application.fetch_env!(:notifications, NotificationsWeb.NotificationsChannel)
  @broadcasting_key Keyword.get(@config, :broadcasting_key)

  @impl true
  def join("notifications:"<> _topic_name, _payload, socket) do
      {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (notifications:topic_name).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcasting_key = Map.get(payload, "broadcasting_key")

    if authorized?(broadcasting_key) do
      body = Map.get(payload, "body")
      broadcast(socket, "shout", body)
    end
    {:noreply, socket}
  end

  # Checks if the broadcaster is authorized.
  defp authorized?(broadcasting_key) when broadcasting_key == @broadcasting_key do
    true
  end
  defp authorized?(_), do: false
end
