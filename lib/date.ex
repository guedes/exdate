alias Erlang.calendar, as: Calendar

defmodule Date do
  @moduledoc """
  This module provides facilities to work with Date and Time
  """

  defrecord Info, year: 1, month: 1, day: 1, hour: 0, minute: 0, second: 0, milisecond: 0.0, as_tuple: {{0,0,0},{0,0,0}}

  @doc """
  Returns a Date record.

  ## Example

      date = Date.new("2011-01-01 12:35:48")
      date.year   #=> "2011"
      date.month  #=> "01"
      date.day    #=> "01"
      date.hour   #=> "12"
      date.minute #=> "35"
      date.second #=> "48"

  """
  def new(string) when is_binary(string) do
    regex = %r/^(\d{4})-(\d{1,2})-(\d{1,2})( (\d{1,2}):(\d{1,2}):(\d{1,2}))?$/
    destructure [ _, year, month, day, _, hour, minute, second ], Regex.run(regex, string)

    info = Date.Info[
      year:   to_year(year),
      month:  to_month(month),
      day:    to_day(day),
      hour:   to_hour(hour),
      minute: to_minute(minute),
      second: to_second(second),
      as_tuple: {{to_year(year), to_month(month), to_day(day)},{to_hour(hour),to_minute(minute),to_second(second)}}
    ]

    info
  end

  def new({{year, month, day},{hour, minute, second}}) do
    info = Date.Info[
      year:   to_year(year),
      month:  to_month(month),
      day:    to_day(day),
      hour:   to_hour(hour),
      minute: to_minute(minute),
      second: to_second(second),
      as_tuple: {{to_year(year), to_month(month), to_day(day)},{to_hour(hour),to_minute(minute),to_second(second)}}
    ]

    info
  end

  @doc """
  Returns the given date plus `n` seconds.

  ## Examples

      date = Date.new("2011-11-13 10:12:58")
      date = Date.add date, 30, :minutes
      #=> "2011-11-13 10:42:58"

  """
  def add(date, n, :seconds) do
    seconds = Calendar.datetime_to_gregorian_seconds(date.as_tuple) + n
    Date.new(Calendar.gregorian_seconds_to_datetime(seconds))
  end

  def add(date, n, :minutes) do
    add(date, n*60, :seconds)
  end

  def add(date, n, :hours) do
    add(date, n*60, :minutes)
  end

  def add(date, n, :days) do
    add(date, n*24, :hours)
  end

  @doc """
  Allows more date time computation in a single line.

  ## Examples

      date = Date.new("1992-02-18 03:10:20")
      date = Date.add date, days: 10, hours: 2, minutes: 3, seconds: 30
      #=> "1992-02-28 05:13:50"
  """
  def add(date, values) when is_list(values) do
    Enum.reduce values, date, fn(v, d) ->
      add(d, v[2], v[1])
    end
  end

  @doc """
  Returns true if the given date time is valid

  ## Examples

      Date.is_valid_date? "2012-02-28"  #=> true
      Date.is_valid_date? "1010-07-02"  #=> true
      Date.is_valid_date? "1010-7-2"    #=> true

      Date.is_valid_date? "2012-13-2"   #=> false
      Date.is_valid_date? "2013-02-29"  #=> false
      Date.is_valid_date? "2000-01-35"  #=> false
  """
  def is_valid_date?(date) when is_record(date, Date.Info) do
    is_valid_date?(date.as_tuple[1])
  end

  def is_valid_date?({date, _}) when is_tuple(date) do
    is_valid_date?(date)
  end

  def is_valid_date?(date) when is_tuple(date) do
    Calendar.valid_date(date)
  end

  def is_valid_date?(date) when is_binary(date) do
    date = Date.new(date).as_tuple[1]
    is_valid_date?(date)
  end

  def is_valid_date?(_), do: false

  @doc """
  Returns actual localtime.

  ## Examples

      now = Date.now
      #=> "2012-05-11 22:23:50"
  """
  def now() do
    Date.new(Calendar.local_time)
  end

  @doc """
  Returns a formatted string from a Date

  ## Examples

      date = Date.new("2000-01-01 23:59:59")
      Date.format(date, "%Y-%m-%d %H:%M:%S")
      #=> "2000-01-01 23:59:59"
  """
  def format(date, pattern) when is_record(date, Date.Info) and is_binary(pattern) do
    parse_format(date, pattern)
  end

  # private

  defp parse_format(date, <<?%,mod,rest|:binary>>) do
    mod2date(date,mod) <> parse_format(date, rest)
  end

  defp parse_format(date, <<char,rest|:binary>>) do
    "#{char}" <> parse_format(date, rest)
  end

  defp parse_format(_date, <<>>), do: <<>>

  defp mod2date(date,mod) do
    value = case mod do
    ?Y ->
      date.year
    ?m ->
      left_zeroes(date.day)
    ?d ->
      left_zeroes(date.day)
    ?H ->
      left_zeroes(date.hour)
    ?M ->
      left_zeroes(date.minute)
    ?S ->
      left_zeroes(date.second)
    end

    "#{value}"
  end

  defp left_zeroes(v) do
    to_binary(:string.right(integer_to_list(v), 2, ?0))
  end

  defp to_year(s) when is_binary(s), do: to_integer(s)
  defp to_year(x) when x >= 0, do: x

  defp to_month(s) when is_binary(s), do: to_integer(s)
  defp to_month(x) when x >= 1 and x <= 12, do: x

  defp to_day(s) when is_binary(s), do: to_integer(s)
  defp to_day(x) when x >= 1 and x <= 31, do: x

  defp to_hour(s) when is_binary(s), do: to_integer(s)
  defp to_hour(x) when x >= 0 and x <= 23, do: x
  defp to_hour(nil), do: 0

  defp to_minute(s) when is_binary(s), do: to_integer(s)
  defp to_minute(x) when x >= 0 and x <= 59, do: x
  defp to_minute(nil), do: 0

  defp to_second(s) when is_binary(s), do: to_integer(s)
  defp to_second(x) when x >= 0 and x <= 59, do: x
  defp to_second(nil), do: 0

  defp to_integer(s), do: list_to_integer(binary_to_list(s))
end
