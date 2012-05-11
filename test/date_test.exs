Code.require_file "../test_helper.exs", __FILE__

defmodule Date.AddTest do
  use ExUnit.Case

  test :store_each_date_part do
    date = Date.new("2011-01-01 12:35:48")
    assert 2011 == date.year
    assert    1 == date.month
    assert    1 == date.day
    assert   12 == date.hour
    assert   35 == date.minute
    assert   48 == date.second
  end

  test :adds_3_seconds do
    date = Date.new("2011-10-12 14:15:58")
    date_expected = Date.new("2011-10-12 14:16:01")

    assert date_expected == Date.add date, 3, :seconds
  end

  test :adds_30_minutes do
    date = Date.new("2011-11-13 10:12:58")
    date_expected = Date.new("2011-11-13 10:42:58")

    assert date_expected == Date.add date, 30, :minutes
  end

  test :adds_5_hours do
    date = Date.new("2012-10-13 20:12:58")
    date_expected = Date.new("2012-10-14 1:12:58")

    assert date_expected == Date.add date, 5, :hours
  end

  test :adds_2_days do
    date = Date.new("2012-02-28 1:12:58")
    date_expected = Date.new("2012-03-01 1:12:58")

    assert date_expected == Date.add date, 2, :days
  end

  test :is_valid_date do
    assert Date.is_valid_date? "2012-02-28"
    assert Date.is_valid_date? "1010-07-02"
    assert Date.is_valid_date? "1010-7-2"

    refute Date.is_valid_date? "2012-13-2"
    refute Date.is_valid_date? "2013-02-29"
    refute Date.is_valid_date? "2000-01-35"
  end

  test :more_complex_interval do
    date = Date.new("1992-02-18 03:10:20")
    expected_date = Date.new("1992-02-28 05:13:50")
    result_date = Date.add date, days: 10, hours: 2, minutes: 3, seconds: 30

    assert expected_date == result_date
  end

end
