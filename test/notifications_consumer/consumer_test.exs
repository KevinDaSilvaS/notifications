defmodule NotificationsConsumer.ConsumerTest do
  ExUnit.start()

  use ExUnit.Case, async: true

  test "should call handle_batch successfully" do
    result = NotificationsConsumer.Consumer.handle_batch([], [], [], [])
    assert is_list(result)
  end
end
