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

  def require_profile
    user = current_user.id == params[:user_id].to_i ? current_user : @user
    unless user.profile.present?
      redirect_to user_path(user),
                  notice: user.id == current_user.id ?
                    'You have no profile data so your calendar page is unavailable.' :
                    'User has no profile data so his calendar page is unavailable.'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_calendar
    @settings = get_data_for_timeline(@user)
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

  def get_data_for_timeline(user)
    my_orders = Order.where(customer_id: user.id)
    query = Service.where(user_id: user.id).ids
    ordered_at_me = Order.where('service_id in (:ids)', ids: query)
    # my_orders.or(ordered_at_me) means all the orders displayed at calendar

    {is_mine: user.id == current_user.id,
     calendar: user.calendar,
     my_orders: my_orders,
     ordered_at_me: ordered_at_me}
  end

end