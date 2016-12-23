class ServicesService

  def new_service(user_id, permitted_params = nil)
    if permitted_params.nil?
      service = Service.new
    else
      service = Service.new(permitted_params)
    end
    service.user_id = user_id
    service
  end

  # Use callbacks to share common setup or constraints between actions.

  def update_text_search_column(provider, service)
    service.textsearchable_index_col =
      provider.profile.personaldata['name'] + ' ' +
      service.servicedata['name'] + ' ' +
      service.servicedata['description']
  end

  # TODO all checks seems to look different.
  # @param [User] user
  # @param [Service] service
  # @param [DateTime] order_time
  def booking_is_available?(user, service, order_time)
    order_time > Time.new + 6.hours and user.id != service.user_id
  end

  # @see format_booking_date
  # @param [User] user who books the service
  # @param [Service] service being booked
  # @param [DateTime] order_time when service is gonna be booked
  def booking_performed?(user, service, order_time)
    # second check is needed because service may already be booked between user clicks
    if booking_is_available?(user, service, order_time)
      Order.create!(
        customer_id: user.id,
        service_id: service.id,
        start_time: order_time,
        duration: service.servicedata['duration']
      )
      return true
    end
    false
  end

  # @param [Date] day
  # @param [String] hours
  # @param [String] minutes
  # @return [DateTime] day + hours + minutes
  def format_booking_date(day, hours, minutes)
    day + hours.to_i.hours + minutes.to_i.minutes
  end

end