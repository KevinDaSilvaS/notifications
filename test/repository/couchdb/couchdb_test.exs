defmodule Couchdb.CouchdbTest do
  ExUnit.start()

  use ExUnit.Case, async: true

  defmodule HttpClientMockSuccess do
    def post(_url, _body) do
      """
      {\"docs\": [

      ]}
      """
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
        "[] "
    end
  end

  defmodule HttpClientMockInsertManySuccess do
    def post(_url, _body) do
      """
      {\"error\": \"reason\"}
      """
    end
  end

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
