module CalendarsService

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
    {user: user,
     my_orders: my_orders,
     ordered_at_me: ordered_at_me}
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
      serving_finish <= CalendarsController::MINUTES_IN_DAY and
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
    'SELECT orders.*, users.id provider_id
    FROM orders
    JOIN services ON orders.service_id = services.id
    JOIN users ON services.user_id = users.id
    WHERE orders.service_id IN (
      SELECT id FROM services WHERE orders.customer_id = ' + user_id +
    ')'
  end

  def ordered_at_me_sql(user_id)
    'SELECT orders.*, ' + user_id + ' provider_id, profiles.personaldata personal_info
    FROM orders
    JOIN profiles ON profiles.user_id = orders.customer_id
    WHERE service_id IN (
      SELECT id FROM services WHERE user_id = ' + user_id +
    ')'
  end

end