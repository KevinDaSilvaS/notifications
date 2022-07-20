defmodule NotificationsWeb.NotificationsController do
  alias Services.NotificationsService
  use NotificationsWeb, :controller

  def get_notifications(conn, _opts) do
    func = fn -> %{:hello => "World"} end
    body = NotificationsService.get_notifications(func)
    conn |> put_status(200) |> json(body)
  end
end
