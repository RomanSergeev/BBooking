class CalendarsService

  MINUTES_IN_DAY = 1440

  # @param [User] user whose calendar data we're acquiring
  # @param [Boolean] user_is_provider whether user is a provider of services.
  # On a booking page there's always provider and a customer
  def get_data_for_timeline(user, user_is_provider)
    my_orders = ApplicationRecord.connection.execute(my_orders_sql(user.id.to_s))
    ordered_at_me = ApplicationRecord.connection.execute(ordered_at_me_sql(user.id.to_s))
    # my_orders.or(ordered_at_me) means all the orders displayed at calendar

    # maybe adding user here is a bad practice
    {
      user: user,
      my_orders: my_orders,
      ordered_at_me: ordered_at_me,
      all_time_marks: get_all_interval_marks(user, my_orders, ordered_at_me),
      free_time_intervals: get_free_interval_sets(user, user_is_provider, my_orders, ordered_at_me)
    }
  end

  # @param [Hash] customer_calendar_data == data_for_timeline for customer
  # @param [Hash] provider_calendar_data == data_for_timeline for provider
  # @param [Service] service being booked
  def get_free_intervals_for(customer_calendar_data, provider_calendar_data, service)
    IntervalSet::availability_intervals(
      customer_calendar_data[:free_time_intervals],
      provider_calendar_data[:free_time_intervals],
      service.servicedata['duration'].to_i
    )
  end

  # for calendar preferences,
  # if 0 < serving_start < break_start < break_finish < serving_finish < MINUTES_IN_DAY
  # and 0 <= rest_time <= 60
  # then it's allright and calendar can be updated
  # @param [json] json representing Calendar.preferences
  def check_for_correct_calendar_data?(json)
    serving_start = json['serving_start'].to_i
    break_start = json['break_start'].to_i
    break_finish = json['break_finish'].to_i
    serving_finish = json['serving_finish'].to_i
    rest_time = json['rest_time'].to_i
    unless
    serving_start >= 0 and
      break_start >= serving_start and
      break_finish >= break_start and
      serving_finish >= break_finish and
      serving_finish <= MINUTES_IN_DAY and
      rest_time >= 0 and
      rest_time <= 60
      return false
    end
    true
  end

  # border values are decreased by 1 for correct users' booking intervals representation
  # @param [json]
  def update_preferences_border_values(json)
    json['serving_start'] = json['serving_start'].to_i - 1
    json['break_finish'] = json['break_finish'].to_i - 1
  end

  private

  # getting set of time intervals (in minutes) when this user is available
  # @see get_data_for_timeline which passes all params
  # @param [User] user whose calendar data we're acquiring
  # @param [Boolean] user_is_provider whether user is a provider of services
  # @param [ActiveRecord::Relation] user_orders his own orders
  # @param [ActiveRecord::Relation] orders_at_user all orders made to the user
  def get_free_interval_sets(user, user_is_provider, user_orders, orders_at_user)
    return nil unless user.calendar.preferences['serving_start']
    ultimate_set = IntervalSet.new([0..MINUTES_IN_DAY - 1])
    if user_is_provider
      prefs = user.calendar.preferences
      ultimate_set.exclude!(0..prefs['serving_start'].to_i)
      ultimate_set.exclude!(prefs['break_start'].to_i..prefs['break_finish'].to_i)
      ultimate_set.exclude!(prefs['serving_finish'].to_i..MINUTES_IN_DAY - 1)
    end
    user_orders.each do |order|
      start_time = DateTime.parse(order['start_time'])
      start_minutes = start_time.hour * 60 + start_time.min
      ultimate_set.exclude!(start_minutes..start_minutes + order['duration'])
    end
    orders_at_user.each do |order|
      start_time = DateTime.parse(order['start_time'])
      start_minutes = start_time.hour * 60 + start_time.min
      rest_time = order['rest_time'] > 0 ? order['rest_time'] - 1 : 0
      ultimate_set.exclude!(start_minutes..start_minutes + order['duration'] + rest_time)
    end
    ultimate_set
  end

  # getting all the time points when user's events
  # (booked services or provided services) start or end
  def get_all_interval_marks(user, user_orders, orders_at_user)
    return nil unless user.calendar.preferences['serving_start']
    result = [0]
    prefs = user.calendar.preferences
    result << prefs['serving_start'].to_i + 1
    result << prefs['break_start'].to_i
    result << prefs['break_finish'].to_i + 1
    result << prefs['serving_finish'].to_i
    user_orders.each do |order|
      start_time = DateTime.parse(order['start_time'])
      start_minutes = start_time.hour * 60 + start_time.min
      result << start_minutes
      result << start_minutes + order['duration']
    end
    orders_at_user.each do |order|
      start_time = DateTime.parse(order['start_time'])
      start_minutes = start_time.hour * 60 + start_time.min
      rest_time = order['rest_time'] > 0 ? order['rest_time'] - 1 : 0
      result << start_minutes
      result << start_minutes + order['duration'] + rest_time
    end
    result << MINUTES_IN_DAY
    result.uniq!
    result.sort { |x, y| x.to_i <=> y.to_i }
    result
  end

  # get all services (with their additional info) ordered by user with id == user_id for today
  # @param [Integer] user_id id of user whose orders we're acquiring
  def my_orders_sql(user_id)
    'SELECT
      orders.*,
      users.id provider_id,
      profiles.personaldata customer_personal_info,
      services.servicedata service_info
    FROM orders
    JOIN services ON orders.service_id = services.id
    JOIN users ON services.user_id = users.id
    JOIN profiles ON profiles.user_id = orders.customer_id
    WHERE orders.service_id IN (
      SELECT id FROM services WHERE orders.customer_id = ' + user_id +
    ')
    AND orders.start_time BETWEEN
      (SELECT TIMESTAMP \'today\') AND
      (SELECT TIMESTAMP \'tomorrow\')'
  end

  # get all customers (with their additional info) of any services provided by our user
  # when services execution day is today
  # @param [Integer] user_id id of user who is a provider
  def ordered_at_me_sql(user_id)
    'SELECT
      orders.*, ' +
      user_id + ' provider_id,
      profiles.personaldata customer_personal_info,
      services.servicedata service_info
    FROM orders
    JOIN profiles ON profiles.user_id = orders.customer_id
    JOIN services ON services.id = orders.service_id
    WHERE orders.service_id IN (
      SELECT id FROM services WHERE user_id = ' + user_id +
    ')
    AND orders.start_time BETWEEN
      (SELECT TIMESTAMP \'today\') AND
      (SELECT TIMESTAMP \'tomorrow\')'
  end

end