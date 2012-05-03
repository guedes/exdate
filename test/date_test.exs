Code.require_file "../test_helper.exs", __FILE__

defmodule DateTest do
  use ExUnit.Case

  test :store_each_date_part do
    date = Date.new("2011-01-01 12:35:48")
    assert "2011" == date.year
    assert "01" == date.month
    assert "01" == date.day
    assert "12" == date.hour
    assert "35" == date.minute
    assert "48" == date.second
  end
end
