class ServicesController < ApplicationController
  include UsersService
  include CalendarsService
  include ServicesService
  layout 'user' # TODO change to services new own layout

  # GET /services/1
  # GET /services/1.json
  def show
    set_service
    init_presenter
    render 'show', locals: { view_data: @services_presenter.show_data(@service.servicedata) }
  end

  # GET /services/new
  def new
    require_profile? or return
    init_presenter
    @service = Service.new
    @service.user_id = current_user.id
  end

  # GET /services/1/edit
  def edit
    set_service
    require_permission
    init_presenter
  end

  # POST /services
  # POST /services.json
  def create

    @service = Service.new(service_params)
    @service.user_id = current_user.id
    @service.servicedata = params[:service][:servicedata]
    @service.textsearchable_index_col = @service.servicedata['name'] +
      ' ' + @service.servicedata['description']

    respond_to do |format|
      if @service.save
        format.html { redirect_to show_services_path(current_user.id),
                                  notice: 'Service was successfully created.' }
        format.json { render :show,
                             locals: { view_data: @services_presenter.show_data(@service.servicedata) },
                             status: :created,
                             location: @service }
      else
        init_presenter
        format.html { render :new,
                             locals: { view_data: @services_presenter.form_data(@service.servicedata) } }
        format.json { render json: @service.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    set_service
    require_permission
    @service.servicedata = params[:service][:servicedata]
    @service.textsearchable_index_col = @service.servicedata['name'] +
      ' ' + @service.servicedata['description']
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    set_service
    require_permission
    @service.destroy
    respond_to do |format|
      format.html { redirect_to edit_services_path(@provider), notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def book
    require_profile? or return
    set_service
    prevent_own_booking
    init_calendars_presenter
    @my_calendar_data = get_data_for_timeline(current_user)
    @provider_calendar_data = get_data_for_timeline(@provider, true)
    @free_intervals = IntervalSet::availability_intervals(
      @my_calendar_data[:free_time_intervals],
      @provider_calendar_data[:free_time_intervals],
      @service.servicedata['duration'].to_i
    )
  end

  def book_payment
    require_profile? or return
    set_service
    prevent_own_booking
    init_presenter
    day, hours, minutes = Date.today, params[:bookAtHours], params[:bookAtMinutes]
    # TODO replace Date.today with date from request (date picker)
    if booking_is_unavailable?(current_user, @service, format_booking_date(day, hours, minutes))
      puts 'Booking is unavailable!'
      redirect_to service_path(@service),
                  notice: 'Something went wrong and booking is unavailable.'
    else
      render 'book_payment', locals: {
        view_data: @services_presenter.book_payment_data(day, hours, minutes)
      }
    end
  end

  def booking_completed
    require_profile? or return
    set_service
    prevent_own_booking
    init_presenter
    if booking_performed?(current_user,
                          @service,
                          format_booking_date(Date.parse(params[:day]), params[:hours], params[:minutes]))
      message = 'You\'ve successfully booked the service.'
    else
      message = 'Something went wrong and booking was cancelled.'
    end
    render 'booking_completed', locals: {
      view_data: @services_presenter.booking_completed_data(message)
    }
  end

  private

  def booking_performed?(user, service, order_time)
    # second check is needed because service may already be booked between user clicks
    unless booking_is_unavailable?(user, service, order_time)
      Order.create!(
        customer_id: user.id,
        service_id: service.id,
        start_time: order_time,
        duration: service.servicedata['duration'])
      return true
    end
    false
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:servicedata)
  end
end
