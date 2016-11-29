module CalendarsHelper
  def width(minute_block)
    minute_block.to_i / CalendarsController::TIMELINE_PERCENT
  end
end
