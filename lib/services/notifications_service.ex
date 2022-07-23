defmodule Services.NotificationsService do
  def get_notifications(repository) do
    {:ok, notifications} = repository.()
    notifications
  end

  def insert_notifications(repository) do
    repository.()
  end
end
