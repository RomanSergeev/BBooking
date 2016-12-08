class CalendarsPresenter

  def initialize(current_user_id)
    @current_user_id = current_user_id
  end

  def max_minute
    CalendarsService::MINUTES_IN_DAY - 1
  end

  def show_data(user)
    is_mine = user.id == @current_user_id
    {
      is_mine: is_mine,
      calendar_title_text: is_mine ? 'My current calendar:' : user.profile.personaldata['name'] + '\'s calendar:',
      timeline_data: user.calendar.preferences,
      id: user.id
    }
  end

  def edit_data(calendar)
    prefs = calendar.preferences
    serving_start = prefs['serving_start'].to_i || 1
    serving_finish = prefs['serving_finish'].to_i || max_minute
    break_start = prefs['break_start'].to_i || 0
    break_finish = prefs['break_finish'].to_i || max_minute
    rest_time = prefs['rest_time'].to_i || 5
    {
      calendar: calendar,
      serving_start: serving_start + 1,
      serving_finish: serving_finish,
      break_start: break_start,
      break_finish: break_finish + 1,
      rest_time: rest_time
    }
  end

  # @param [jsonb] calendar_preferences
  # @param [id] id of user whose calendar is considered
  def calendar_timeline_data(calendar_preferences, id)
    break_is_present = calendar_preferences['break_start'] && calendar_preferences['break_finish']
    break_start = break_is_present ? calendar_preferences['break_start'] : nil
    break_finish = break_is_present ? calendar_preferences['break_finish'] : nil
    break_length = break_is_present ? break_finish.to_i - break_start.to_i : nil
    {
      id: id,
      serving_start: calendar_preferences['serving_start'] || 0,
      serving_finish: calendar_preferences['serving_finish'] || max_minute,
      break_start: break_start,
      break_finish: break_finish,
      break_length: break_length
    }
  end

  # @param [Hash] order from queries from CalendarsService
  # @param [Integer] id whose calendar we are looking at
  def calendar_item_data(order, id)
    order.symbolize_keys!
    my_order = order[:customer_id] == @current_user_id
    ordered_at_me = order[:provider_id] == @current_user_id
    class_name = my_order ? 'tl-my-order' : ordered_at_me ? 'tl-ordered-at-me' : 'tl-sided-order'
    profile_info = JSON.parse(order[:customer_personal_info])
    service_info = JSON.parse(order[:service_info])
    title = my_order ? 'I\'ve ordered' : "#{profile_info['name']} has ordered"
    time = DateTime.parse(order[:start_time])
    duration = order[:duration].to_i
    minutes = time.hour * 60 + time.min
    description = "Service #{service_info['name']} " +
      "starts at #{time.strftime('%H:%M')} " +
      "and lasts #{duration} minutes."
    {
      class_name: class_name,
      duration: duration,
      minutes: minutes,
      description: description,
      title: title,
      rest_time: order[:rest_time],
      rest_offset: duration + minutes,
      should_render_rest: order[:provider_id] == id && order[:rest_time] > 0
    }
  end

end