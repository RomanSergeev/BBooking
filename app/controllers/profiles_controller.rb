class ProfilesController < ApplicationController
  layout 'user'

  def new
    @profile = Profile.new(user_id: current_user.id, personaldata: {name: '', phone: ''})
  end

  def edit
    @profile = Profile.where(user_id: current_user.id)[0]
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
    @profile = Profile.find(params[:id])
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