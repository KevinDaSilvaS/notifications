defmodule Couchdb do

  use Agent
  require Logger

  @callback start_link(arg :: any) :: any
  def start_link(config) do
    username = Map.get(config, :username)
    password = Map.get(config, :password)
    host = Map.get(config, :host, "localhost")
    port = Map.get(config, :port, 5984)
    db_name = Map.get(config, :db_name)
    couchdb_url = "http://#{username}:#{password}@#{host}:#{port}/#{db_name}/"
    http_client = Map.get(config, :http_client, Couchdb.HttpClient)
    process_name = Map.get(config, :name)

    config = Map.merge(
      config,
      %{http_client: http_client, couchdb_url: couchdb_url}
    )
    setup_db(config)
    index = Map.get(config, :index)
    set_index(index, {couchdb_url, http_client})
    Agent.start_link(fn -> config end, name: process_name)
  end

  def get_config(name) do
    Agent.get(name, & &1)
  end

  defp setup_db(config) do
    couchdb_url = Map.get(config, :couchdb_url)
    http_client = Map.get(config, :http_client)
    res = http_client.put(couchdb_url)

    body = Jason.decode!(res.body)
    case body["ok"] do
      true -> Logger.info("Database successfully created")
      _ -> Logger.error(body)
    end
  end

  defp set_index(nil, _), do: nil
  defp set_index(index, {couchdb_url, http_client}) do
    fields = Map.get(index, :fields)
    index_name = Map.get(index, :index_name)
    index_type = Map.get(index, :index_type)
    index = %{
      "index" => %{
          "fields" => fields
      },
      "name" => index_name,
      "type" => index_type
    }
    create_index_url = couchdb_url <> "_index"
    res = http_client.post(create_index_url, index)
    body = Jason.decode!(res.body)

    case body["error"] do
      nil -> Logger.info("Index successfully created")
      _ -> Logger.error(body)
    end
  end

  def find(fields, selector, sort, {limit, page}, process_name) do
    config = get_config(process_name)
    couchdb_url = Map.get(config, :couchdb_url)
    http_client = Map.get(config, :http_client)
    find_url = couchdb_url <> "_find"
    body = %{
      "selector" => selector,
      "fields"   => fields,
      "sort"     => sort,
      "limit"    => limit,
      "skip"     => (page-1)*limit,
      "execution_stats" => false
    }

    res = http_client.post(find_url, body)
    body = Jason.decode!(res.body)

    case body["error"] do
      nil -> {:ok, body["docs"]}
      _ -> {:error, body}
    end
  end

  def insert_one(register, process_name) do
    config = get_config(process_name)
    couchdb_url = Map.get(config, :couchdb_url)
    http_client = Map.get(config, :http_client)

    res = http_client.post(couchdb_url, register)
    body = Jason.decode!(res.body)
    case body["error"] do
      nil -> {:ok, body}
      _ -> {:error, body["error"]}
    end
  end

  def insert_many(registers, process_name) do
    config = get_config(process_name)
    couchdb_url = Map.get(config, :couchdb_url)
    http_client = Map.get(config, :http_client)
    docs = %{"docs" => registers}
    insert_many_url = couchdb_url <> "_bulk_docs"

    res = http_client.post(insert_many_url, docs)
    body = Jason.decode!(res.body)
    case many_inserted?(body) do
      true -> {:ok, body}
      _ -> {:error, body}
    end
  end

  defp many_inserted?(body) when is_list(body) do
    true
  end
  defp many_inserted?(_) do
    false
  end
end
