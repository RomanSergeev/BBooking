module ServicesService

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
    @provider = User.preload(:profile).find(@service.user_id)
  end

  def update_text_search_column(service)
    service.textsearchable_index_col = service.servicedata['name'] +
      ' ' + service.servicedata['description']
  end

  def init_presenter
    @services_presenter = ServicesPresenter.new
  end

  def init_calendars_presenter
    @calendars_presenter = CalendarsPresenter.new(current_user.id)
  end

  def require_permission
    if @provider.id != current_user.id
      redirect_to user_path(current_user),
                  notice: 'Editing or deleting of other\'s service is forbidden.'
    end
  end

  def prevent_own_booking
    if @provider.id == current_user.id
      redirect_to user_path(current_user),
                  notice: 'You cannot book your own services!'
    end
  end

  # TODO all checks seems to look different.
  # @param [User] user
  # @param [Service] service
  # @param [DateTime] order_time
  def booking_is_available?(user, service, order_time)
    order_time > Time.new + 6.hours and user.id != service.user_id
  end

  # @param [Date] day
  # @param [String] hours
  # @param [String] minutes
  def format_booking_date(day, hours, minutes)
    day + hours.to_i.hours + minutes.to_i.minutes
  end

end