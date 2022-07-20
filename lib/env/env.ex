defmodule Env do
  def broadcasting_key(), do: "admin"

  def socket_url(), do: ""

  def limit(), do: 15

  def page(), do: 1

  def rabbit_host(), do: ""

  def rabbit_port(), do: 5672

  def db_password() do
    ""
  end

  def db_user() do
    ""
  end

  def db_port() do
    ""
  end

  def db_host() do
    ""
  end
end
