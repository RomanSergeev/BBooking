class ProfilesController < ApplicationController
  layout 'user'

  def initialize
    super
    @profiles_service = ProfilesService.new
  end

  def new
    @profile = @profiles_service.new_profile(current_user)
  end

  def edit
    @profile = @profiles_service.find_profile(params[:id])
    require_permission?
  end

  def create
    @profile = @profiles_service.new_profile(current_user, params)
    if @profile.save
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def update
    @profile = @profiles_service.find_profile(params[:id])
    require_permission? or return
    if @profile.update_attributes(personaldata: params[:profile])
      redirect_to user_path(current_user)
    else
      render 'edit'
    end
  end

  private

  def require_permission?
    if @profile.user_id != current_user.id
      redirect_to user_path(current_user.id),
                  notice: 'Editing of other\'s profile is forbidden.'
      return false
    end
    true
  end

  # now unused, may be used later
  def profile_params
    params.require(:profile).permit(:personaldata['name'], :personaldata['phone'])
  end

end