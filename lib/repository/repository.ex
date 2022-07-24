defmodule Repository.Notifications do
  @behaviour Couchdb

  use Agent
  @instance_name Couchdb.Notifications

  @config Application.fetch_env!(:couchdb, Repository.Notifications)
  @username Keyword.get(@config, :user)
  @password Keyword.get(@config, :password)
  @host Keyword.get(@config, :host)
  @port Keyword.get(@config, :port)
  def start_link(_) do
    index = %{
      :fields     => ["created_date"],
      :index_name => "date-index",
      :index_type => "json"
    }

    config = %{
      :username => @username,
      :password => @password,
      :db_name  => "notifications",
      :host     => @host,
      :port     => @port,
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
