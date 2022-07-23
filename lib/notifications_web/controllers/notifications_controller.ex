defmodule NotificationsWeb.NotificationsController do
  alias Services.NotificationsService
  use NotificationsWeb, :controller
  alias NotificationsWeb.Helpers.SetPagination

  def get_notifications(conn, opts) do
    {limit, page} = SetPagination.set(opts)
    topic = Map.get(opts, "topic")

    repository = fn ->
      Repository.Notifications.find_notifications(
        ["topic", "title", "message", "redirect", "created_date"],
        %{"topic" => topic}, [%{"created_date" => "desc"}], limit, page)
    end

    body = NotificationsService.get_notifications(repository)
    conn |> put_status(200) |> json(body)
  end
end
