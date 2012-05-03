
defmodule Date do
  @moduledoc """
  This module provides facilities to work with Date and Time
  """
  
  defrecord Info, year: 1, month: 1, day: 1, hour: 0, minute: 0, second:0, milisecond: 0.0

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
    regex = %r/^(\d{4})-(\d{2})-(\d{2})( (\d{2}):(\d{2}):(\d{2}))?$/
    destructure [ _, year, month, day, _, hour, minute, second ], Regex.run(regex, string)

    info = Date.Info[
      year:   year,
      month:  month,
      day:    day,
      hour:   hour,
      minute: minute,
      second: second
    ]

    info
  end
end
