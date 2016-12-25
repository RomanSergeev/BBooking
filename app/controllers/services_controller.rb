class ServicesController < ApplicationController
  layout 'user' # TODO change to services new own layout

  def initialize
    super
    @calendars_service = CalendarsService.new
    @services_service = ServicesService.new
  end

  # GET /services/1
  # GET /services/1.json
  def show
    set_service_and_provider
    init_presenter
    render 'show', locals: { view_data: @services_presenter.show_data(@service.servicedata) }
  end

  # GET /services/new
  def new
    require_profile?(current_user) or return
    @service = @services_service.new_service(current_user.id)
    init_presenter
  end

  # GET /services/1/edit
  def edit
    set_service_and_provider
    require_permission? or return
    init_presenter
  end

  # POST /services
  # POST /services.json
  def create
    @service = @services_service.new_service(current_user.id, service_params)
    @service.servicedata = params[:service][:servicedata]
    @services_service.update_text_search_column(current_user, @service)
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
    set_service_and_provider
    require_permission? or return
    @service.servicedata = params[:service][:servicedata]
    @services_service.update_text_search_column(current_user, @service)
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
    set_service_and_provider
    require_permission? or return
    @service.destroy
    respond_to do |format|
      format.html { redirect_to edit_services_path(@provider), notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def book
    require_profile?(current_user) or return
    set_service_and_provider
    prevent_own_booking? or return
    my_calendar_data = @calendars_service.get_data_for_timeline(current_user, false)
    provider_calendar_data = @calendars_service.get_data_for_timeline(@provider, true)
    free_intervals = @calendars_service.get_free_intervals_for(
      my_calendar_data,
      provider_calendar_data,
      @service
    )
    init_presenter
    init_calendars_presenter
    render 'book', locals: {
      view_data: @services_presenter.book_data(
        current_user,
        my_calendar_data,
        @provider,
        provider_calendar_data,
        free_intervals
      )
    }
  end

  def book_payment
    require_profile?(current_user) or return
    set_service_and_provider
    prevent_own_booking? or return
    day, hours, minutes = Date.today, params[:bookAtHours], params[:bookAtMinutes]
    # TODO replace Date.today with date from request (date picker)
    if @services_service.booking_is_available?(
      current_user,
      @service,
      @services_service.format_booking_date(day, hours, minutes)
    )
      init_presenter
      render 'book_payment', locals: {
        view_data: @services_presenter.book_payment_data(day, hours, minutes)
      }
    else
      redirect_to service_path(@service),
                  notice: 'Something went wrong and booking is unavailable.'
    end
  end

  def booking_completed
    require_profile?(current_user) or return
    set_service_and_provider
    prevent_own_booking? or return
    if @services_service.booking_performed?(
      current_user,
      @service,
      @services_service.format_booking_date(
        Date.parse(params[:day]),
        params[:hours],
        params[:minutes]
      )
    )
      message = 'You\'ve successfully booked the service.'
    else
      message = 'Something went wrong and booking was cancelled.'
    end
    init_presenter
    render 'booking_completed', locals: {
      view_data: @services_presenter.booking_completed_data(message)
    }
  end

  private

  def require_permission?
    if @provider.id != current_user.id
      redirect_to user_path(current_user.id),
                  notice: 'Editing or deleting of other\'s service is forbidden.'
      return false
    end
    true
  end

  def prevent_own_booking?
    if @provider.id == current_user.id
      redirect_to user_path(current_user.id),
                  notice: 'You cannot book your own services!'
      return false
    end
    true
  end

  def init_presenter
    @services_presenter = ServicesPresenter.new
  end

  def init_calendars_presenter
    @calendars_presenter = CalendarsPresenter.new(current_user.id)
  end

  def set_service_and_provider
    @service = Service.find(params[:id])
    @provider = User.preload(:profile).find(@service.user_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:servicedata)
  end
end
