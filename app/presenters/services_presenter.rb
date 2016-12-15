class ServicesPresenter

  # @param [jsonb] service_data
  def form_data(service_data)
    {
      name: service_data['name'],
      duration: service_data['duration'] || 15,
      description: service_data['description'],
      rest_time: service_data['rest_time'] || 5
    }
  end

  # @param [jsonb] service_data
  def show_data(service_data)
    description = service_data['description']
    if not description.present? or description.empty?
      description = 'No description provided.'
    end
    {
      name: service_data['name'],
      duration: service_data['duration'],
      description: description
    }
  end

  # @param [User] me
  # @param [jsonb] my_calendar_data
  # @param [User] provider
  # @param [jsonb] his_calendar_data
  # @param [IntervalSet] free_intervals
  def book_data(me,
                my_calendar_data,
                provider,
                his_calendar_data,
                free_intervals
  )
    {
      me: me.id,
      my_calendar_data: my_calendar_data,
      my_preferences: my_calendar_data[:user].calendar.preferences,
      provider: provider.id,
      provider_name: provider.profile.personaldata['name'],
      provider_calendar_data: his_calendar_data,
      provider_preferences: his_calendar_data[:user].calendar.preferences,
      booking_is_available: !free_intervals.empty?,
      free_intervals: free_intervals
    }
  end

  # @param [Date] day
  # @param [Integer] hours
  # @param [Integer] minutes
  def book_payment_data(day, hours, minutes)
    {
      day: day,
      hours: hours,
      minutes: minutes
    }
  end

  # @param [String] message
  def booking_completed_data(message)
    {
      message: message
    }
  end

end