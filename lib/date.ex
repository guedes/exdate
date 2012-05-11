refer Erlang.calendar, as: Calendar

defmodule Date do
  @moduledoc """
  This module provides facilities to work with Date and Time
  """

  defrecord Info, year: 1, month: 1, day: 1, hour: 0, minute: 0, second:0, milisecond: 0.0, as_tuple: {{0,0,0},{0,0,0}}

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
  Adds an interval to a date-time

  ## Examples

      date = Date.new("2011-11-13 10:12:58")
      result = Date.add date, 30, :minutes
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

  defp to_year(s) when is_binary(s), do: to_integer(s)
  defp to_year(x) when x >= 0, do: x

  defp to_month(s) when is_binary(s), do: to_integer(s)
  defp to_month(x) when x >= 1 and x <= 12, do: x

  defp to_day(s) when is_binary(s), do: to_integer(s)
  defp to_day(x) when x >= 1 and x <= 31, do: x

  defp to_hour(s) when is_binary(s), do: to_integer(s)
  defp to_hour(x) when x >= 0 and x <= 23, do: x

  defp to_minute(s) when is_binary(s), do: to_integer(s)
  defp to_minute(x) when x >= 0 and x <= 59, do: x

  defp to_second(s) when is_binary(s), do: to_integer(s)
  defp to_second(x) when x >= 0 and x <= 59, do: x

  defp to_integer(s), do: list_to_integer(binary_to_list(s))
end
