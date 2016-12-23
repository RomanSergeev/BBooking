module CalendarsHelper

  # TIMELINE_PERCENT == 1% of day in minutes (useful for rendering calendars)
  TIMELINE_PERCENT = CalendarsService::MINUTES_IN_DAY / 100.0

  def width(minute_block)
    minute_block.to_i / TIMELINE_PERCENT
  end

  def format_width(value)
    "width: #{width(value)}%; "
  end

  def format_left(value)
    "left: #{width(value)}%; "
  end

  def format_width_and_left(width_value, left_value)
    format_width(width_value) + format_left(left_value)
  end

  def format_complement_width(minute_block)
    format_width(CalendarsService::MINUTES_IN_DAY - minute_block.to_i)
  end

  def hours(total_minutes)
    total_minutes / 60
  end

  def minutes(total_minutes)
    total_minutes % 60
  end

end
