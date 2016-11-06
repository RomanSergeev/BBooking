class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  layout 'user' # TODO change to services new own layout

  # GET /services
  # GET /services.json
  def index
    @services = Service.all
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
    @service.user_id = current_user.id
  end

  # GET /services/1/edit
  def edit
    if @provider.id != current_user.id
      redirect_to user_path(current_user), notice: "Editing of other's service is forbidden."
    end
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)
    @service.user_id = current_user.id
    @service.servicedata = params[:service][:servicedata]

    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: 'Service was successfully created.' }
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
    @service.destroy
    respond_to do |format|
      format.html { redirect_to edit_services_path(@provider), notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
      @provider = User.preload(:profile).find(@service.user_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:servicedata)
    end
end
