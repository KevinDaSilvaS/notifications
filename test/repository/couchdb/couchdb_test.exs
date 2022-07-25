defmodule Couchdb.CouchdbTest do
  ExUnit.start()

  use ExUnit.Case, async: true

  defmodule HttpClientMockSuccess do
    def post(_url, _body) do
      %{body: """
      {\"docs\": [

      ]}
      """}
    end

    def put(_) do
      %{body: """
      {\"ok\": [

      ]}
      """}
    end
  end

  defmodule HttpClientMockInsertManySuccess do
    def post(_url, _body) do
      %{body: "[] "}
    end

    def put(_) do
      HttpClientMockSuccess.put(:call)
    end
  end

  defmodule HttpClientMockError do
    def post(_url, _body) do
      %{body: """
      {\"error\": \"reason\"}
      """}
    end

    def put(_) do
      HttpClientMockSuccess.put(:call)
    end
  end

  describe "start_link" do
    test "should call start_link successfully and start Couchdb instance" do
      config = %{
        :username => "user",
        :password => "12345",
        :host => "172.17.0.4",
        :db_name => "test_start_link",
        :http_client => HttpClientMockSuccess,
        :name => Test.StartLink
      }

      {:ok, _} = Couchdb.start_link(config)
      assert true
    end
  end

  describe "find" do
    test "should call find successfully and list all registers" do
      config = %{
        :username => "user",
        :password => "12345",
        :host => "172.17.0.4",
        :db_name => "test_find",
        :http_client => HttpClientMockSuccess,
        :name => Test.Find
      }

      {:ok, _} = Couchdb.start_link(config)
      query = Couchdb.find([], %{}, %{}, {10, 1}, Test.Find)
      assert query == {:ok, []}
    end

    test "should call find when an error occurs" do
      config = %{
        :username => "user",
        :password => "12345",
        :host => "172.17.0.4",
        :db_name => "test_find",
        :http_client => HttpClientMockError,
        :name => Test.FindError
      }

      {:ok, _} = Couchdb.start_link(config)
      query = Couchdb.find([], %{}, %{}, {10, 1}, Test.FindError)
      assert query == {:error, %{"error" => "reason"}}
    end
  end

  describe "insert_many" do
    test "should call insert_many successfully and insert all registers" do
      config = %{
        :username => "user",
        :password => "12345",
        :host => "172.17.0.4",
        :db_name => "test_insert_many",
        :http_client => HttpClientMockInsertManySuccess,
        :name => Test.InsertMany
      }

      {:ok, _} = Couchdb.start_link(config)
      query = Couchdb.insert_many([], Test.InsertMany)
      assert query == {:ok, []}
    end

    test "should call insert_many when an error occurs" do
      config = %{
        :username => "user",
        :password => "12345",
        :host => "172.17.0.4",
        :db_name => "test_insert_many",
        :http_client => HttpClientMockError,
        :name => Test.InsertManyError
      }

      {:ok, _} = Couchdb.start_link(config)
      query = Couchdb.insert_many([], Test.InsertManyError)
      assert query == {:error, %{"error" => "reason"}}
    end
  end

  describe "get_config" do
    test "should call get_config successfully and start Couchdb instance" do
      config = %{
        :username => "user",
        :password => "12345",
        :host => "172.17.0.4",
        :db_name => "test_get_config",
        :http_client => HttpClientMockSuccess,
        :name => Test.GetConfig
      }
      {:ok, _} = Couchdb.start_link(config)

      expected_keys = [:couchdb_url | Map.keys(config)]
      config_keys = Couchdb.get_config(Test.GetConfig) |> Map.keys()
      assert expected_keys == config_keys
    end
  end
end
