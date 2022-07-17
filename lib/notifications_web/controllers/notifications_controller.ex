defmodule NotificationsWeb.NotificationsController do
  use NotificationsWeb, :controller

  def get_notifications(conn, _opts) do
    conn |> put_status(200) |> json(%{:hello => "World"})
  end
end
