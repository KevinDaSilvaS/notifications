defmodule Repository.Couchdb.HttpClientTest do
  ExUnit.start()

  use ExUnit.Case, async: true

  test "should call get correctly" do
    http_call = Couchdb.HttpClient.get("google.com", %{})
    assert true == response_correct?(http_call)
  end

  def response_correct?(%HTTPoison.Response{
        __struct__: _,
        body: _,
        headers: _,
        request: _,
        request_url: _,
        status_code: _
      }) do
    true
  end

  def response_correct?(_), do: false
end
