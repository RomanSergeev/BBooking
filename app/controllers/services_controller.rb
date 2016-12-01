class ServicesController < ApplicationController
  include UsersService
  include CalendarsService
  include ServicesService
  layout 'user' # TODO change to services new own layout

  # GET /services/1
  # GET /services/1.json
  def show
    set_service
  end

  # GET /services/new
  def new
    require_profile
    @service = Service.new
    @service.user_id = current_user.id
  end

  # GET /services/1/edit
  def edit
    set_service
    require_permission
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)
    @service.user_id = current_user.id
    @service.servicedata = params[:service][:servicedata]

    respond_to do |format|
      if @service.save
        format.html { redirect_to show_services_path(current_user.id), notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    set_service
    require_permission
    @service.servicedata = params[:service][:servicedata]
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
    require_profile
    set_service
    prevent_own_booking
    @my_calendar_data = get_data_for_timeline(current_user)
    @provider_calendar_data = get_data_for_timeline(@provider)
  end

  private

  def perform_booking(user, service, order_time)
    check_booking_available_conditions(user, service, order_time)
    order = Order.new(
      customer_id: user.id,
      service_id: service.id,
      start_time: order_time,
      duration: service.servicedata['duration'])
    order.save!
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:servicedata)
  end
end
