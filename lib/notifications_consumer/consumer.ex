defmodule NotificationsConsumer.Consumer do
  alias Notifications.Socket.SocketClient
  alias Mapper.NotificationMapper
  use Broadway

  #{
   # "topic": "12345",
   # "title": "uma notificacao",
   # "message": "uma notificacao",
   # "redirect": ""
   #}
   @config Application.fetch_env!(:broadway, NotificationsConsumer.Consumer)
   @host Keyword.get(@config, :rabbit_host)
   @socket_url Keyword.get(@config, :socket_url)

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: NotificationsConsumer,
      producer: [
        module:
          {BroadwayRabbitMQ.Producer,
           queue: "notifications",
           declare: [durable: true],
           connection: [
             host: @host
           ],
           on_failure: :reject_and_requeue}
      ],
      processors: [
        default: []
      ],
      batchers: [
        default: []
      ]
    )
  end

  def handle_message(_processor, message, _context) do
    data = Jason.decode!(message.data)
    topic = Map.get(data, "topic")
    topic = "notifications:" <> topic

    {:ok, socket} = SocketClient.connect(uri: @socket_url)
    {:ok, joined_socket} = SocketClient.join_topic(socket, topic)

    notification = NotificationMapper.prepare_notification(data)

    SocketClient.push(joined_socket, topic, notification)

    body = Map.get(notification, "body")
    Map.put(message, :data, body)
  end

  def handle_failed(messages, _context) do
    messages
  end

  def handle_batch(_batcher, messages, _batch_info, _context) do
    notifications = Enum.map(messages, &(Map.get(&1, :data)))
    repository = fn ->
      Repository.Notifications.insert_notifications(notifications)
    end

    Services.NotificationsService.insert_notifications(repository)
    messages
  end
end
