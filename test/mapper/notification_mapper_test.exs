defmodule Mapper.NotificationMapperTest do
  ExUnit.start()

  use ExUnit.Case, async: true

  test "should map notification to expected fields" do
    body = %{
      "topic" => "lobby",
      "title" => "a notification title",
      "message" => "a notification message",
      "redirect" => "myapp.com/stuff-on-sale"
    }

    mapped_result = Mapper.NotificationMapper.prepare_notification(body)
    expected_body_keys = ["created_date" | Map.keys(body)]
    expected_mapped_result_keys = ["body", "broadcasting_key"]

    assert expected_mapped_result_keys == Map.keys(mapped_result)
    assert expected_body_keys == Map.keys(mapped_result["body"])
  end
end
