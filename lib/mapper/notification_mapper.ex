defmodule Mapper.NotificationMapper do
  @broadcasting_key Env.broadcasting_key()
  def prepare_notification(body) do

    created_date = DateTime.now!("Etc/UTC") |> DateTime.to_iso8601()

    body = Map.put_new(body, "created_date", created_date)
    %{
      "body" => body,
      "broadcasting_key" => @broadcasting_key
    }
  end
end
