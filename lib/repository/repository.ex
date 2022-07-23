defmodule Repository.Notifications do
  @behaviour Couchdb

  use Agent
  @instance_name Couchdb.Notifications
  def start_link(_) do
    index = %{
      :fields     => ["created_date"],
      :index_name => "date-index",
      :index_type => "json"
    }

    config = %{
      :username => "user",
      :password => "12345",
      :db_name  => "notifications",
      :host     => "172.17.0.4",
      :port     => 5984,
      :name     => @instance_name,
      :index    => index
    }
    Agent.start_link(fn -> [] end)
    Couchdb.start_link(config)
  end

  def find_notifications(fields, selector, sort, limit, page) do
    Couchdb.find(fields, selector, sort, {limit, page}, @instance_name)
  end

  def insert_notifications(notifications) do
    Couchdb.insert_many(notifications, @instance_name)
  end
end
