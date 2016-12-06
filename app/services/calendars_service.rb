module CalendarsService

  MINUTES_IN_DAY = 1440
  TIMELINE_PERCENT = 1440 / 100.0

  def init_presenter
    @calendars_presenter = CalendarsPresenter.new(current_user.id)
  end

  def find_user
    @user = User.preload(:profile, :calendar).find(params[:user_id])
  end

  def require_permission
    unless @user.id == current_user.id
      redirect_to user_path(@user),
                  notice: 'Editing or deleting of other\'s calendar is forbidden.'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_calendar
    @settings = get_data_for_timeline(@user)
  end

  def get_data_for_timeline(user)
    my_orders = ApplicationRecord.connection.execute(my_orders_sql(user.id.to_s))
    ordered_at_me = ApplicationRecord.connection.execute(ordered_at_me_sql(user.id.to_s))
    # my_orders.or(ordered_at_me) means all the orders displayed at calendar

    # maybe adding user here is a bad practice
    {
      user: user,
      my_orders: my_orders,
      ordered_at_me: ordered_at_me,
      free_time_intervals: get_free_interval_sets(user, my_orders, ordered_at_me)
    }
  end

  def get_free_interval_sets(user, user_orders, orders_at_user)
    ultimate_set = IntervalSet.new([0..MINUTES_IN_DAY - 1])
    prefs = user.calendar.preferences
    ultimate_set.exclude!(0..prefs['serving_start'].to_i)
    ultimate_set.exclude!(prefs['break_start'].to_i..prefs['break_finish'].to_i)
    ultimate_set.exclude!(prefs['serving_finish'].to_i..MINUTES_IN_DAY - 1)
    user_orders.each do |order|
      start_time = DateTime.parse(order['start_time'])
      start_minutes = start_time.hour * 60 + start_time.min
      ultimate_set.exclude!(start_minutes..start_minutes + order['duration'] + order['rest_time'])
    end
    orders_at_user.each do |order|
      start_time = DateTime.parse(order['start_time'])
      start_minutes = start_time.hour * 60 + start_time.min
      ultimate_set.exclude!(start_minutes..start_minutes + order['duration'] + order['rest_time'])
    end
    ultimate_set
  end

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
      redirect_to user_path(@user),
                  notice: 'Parameters for calendar seem to be incorrect.'
      return false
    end
    true
  end

  private

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