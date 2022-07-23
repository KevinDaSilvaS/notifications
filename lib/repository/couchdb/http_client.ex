defmodule Couchdb.HttpClient do
  def post(url, body, headers \\ [{"Content-Type", "application/json"}]) do
    HTTPoison.post!(url, Jason.encode!(body), headers)
  end

  def put(url, body \\ "", headers \\ [{"Content-Type", "application/json"}]) do
    HTTPoison.put!(url, Jason.encode!(body), headers)
  end

  def get(url, headers \\ [{"Content-Type", "application/json"}]) do
    HTTPoison.get!(url, headers)
  end
end
