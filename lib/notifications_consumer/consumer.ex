defmodule NotificationsConsumer.Consumer do
  alias NotificationsWeb.Socket.SocketClient
  use Broadway

  #{
   # "topic": "12345",
   # "message": "uma notificacao",
   # "redirect": ""
   #}

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: NotificationsConsumer,
      producer: [
        module:
          {BroadwayRabbitMQ.Producer,
           queue: "notifications",
           declare: [durable: true],
           connection: [
             host: "172.17.0.2"
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
    {topic, body} = Map.pop(Jason.decode!(message.data), "topic")
    topic = "notifications:" <> topic

    {:ok, socket} = SocketClient.connect(uri: "ws://0.0.0.0:4000/notifications/websocket")
    {:ok, joined_socket} = SocketClient.join_topic(socket, topic)

    SocketClient.push(joined_socket, topic, %{
      "body" => body,
      "broadcasting_key" => "admin"
    })

    message
  end

  def handle_failed(messages, _context) do
    messages
  end

  def handle_batch(_batcher, messages, _batch_info, _context) do
    messages
  end
end
