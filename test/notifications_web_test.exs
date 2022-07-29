defmodule NotificationsWebTest do
  ExUnit.start()

  use ExUnit.Case, async: true

  test " " do
    {block, [], macro_block} = NotificationsWeb.controller()
    assert block == :__block__
    assert is_list(macro_block)
  end

  test "- " do
    {block, [], macro_block} = NotificationsWeb.view()
    assert block == :__block__
    assert is_list(macro_block)
  end

  test " --" do
    {block, [], macro_block} = NotificationsWeb.router()
    assert block == :__block__
    assert is_list(macro_block)
  end
end
