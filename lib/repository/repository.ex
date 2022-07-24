defmodule Repository.Notifications do
  use Agent
  @instance_name Couchdb.Notifications

  @config Application.fetch_env!(:notifications, Repository.Notifications)
  @username Keyword.get(@config, :user)
  @password Keyword.get(@config, :password)
  @host Keyword.get(@config, :host)
  @port Keyword.get(@config, :port)

  @moduledoc """
  An instance of the Couchdb client should call a start_link function
  """

  @doc """
  The instance start_link should be called with a config Map with the following options:
  config = %{
      :username   => Couchdb username,
      :password   => Couchdb password,
      :db_name    => Database name,
      :host       => Optional - Host where couchdb is running default is: localhost,
      :port       => Optional - Port where couchdb is running default is: 5984,
      :name       => Process name,
      :index      => Optional - If you want to index fields for filtering and querying more precisely, the index structure is a map that will be described in more details below
      http_client => Optional - Just in case you want to use a different http client instead of http poison
    }

  index = %{
      :fields     => list of fields you want to index. Ex: ["created_date"],
      :index_name => index name. Ex: "date-index",
      :index_type => type of the index. Ex: "json"
    }
  """
  def start_link(_) do
    index = %{
      :fields => ["created_date"],
      :index_name => "date-index",
      :index_type => "json"
    }

    config = %{
      :username => @username,
      :password => @password,
      :db_name => "notifications",
      :host => @host,
      :port => @port,
      :name => @instance_name,
      :index => index
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
