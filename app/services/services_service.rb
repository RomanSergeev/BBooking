module ServicesService

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
    @provider = User.preload(:profile).find(@service.user_id)
  end

  def require_profile
    unless current_user.profile.present?
      redirect_to user_path(current_user),
                  notice: 'You can\'t create any services while no information about you is present.'
    end
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
    if order_time <= DateTime.now or user.id == service.user_id
      redirect_to :back
    end
  end

end