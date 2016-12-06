module ServicesService

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
    @provider = User.preload(:profile).find(@service.user_id)
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

  def check_booking_available_conditions(user, service, order_time)
    # TODO all checks seems to look different.
    if order_time <= Time.now or user.id == service.user_id
      redirect_to :back
    end
  end

end