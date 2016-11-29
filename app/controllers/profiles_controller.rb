class ProfilesController < ApplicationController
  include ProfilesService
  layout 'user'

  def new
    @profile = Profile.new(user_id: current_user.id, personaldata: {name: '', phone: ''})
  end

  def edit
    require_permission
  end

  def create
    @profile = Profile.new(user_id: current_user.id, personaldata: params[:profile])
    if @profile.save
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def update
    require_permission
    if @profile.update_attributes(personaldata: params[:profile])
      redirect_to user_path(current_user)
    else
      render 'edit'
    end
  end

  private

  # now unused, may be used later
  def profile_params
    params.require(:profile).permit(:personaldata['name'], :personaldata['phone'])
  end

end