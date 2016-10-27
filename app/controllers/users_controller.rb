class UsersController < ApplicationController
  def show
	  @user = User.preload(:profile).find(params[:id])
    render layout: "user"
  end

  def edit
		#redirect_to user_path
  end

  def update
	  @user = User.preload(:profile).find(params[:id])
	  #@user.update(user_params)
	  @user.profile.update(personaldata: params[:personaldata])
	  @user.save
	  render 'show', layout: "user"
  end

	def edit_profile
		@user = User.preload(:profile).find(params[:id])
		render layout: "user"
	end

  def edit_services
	  @user = User.preload(:profile).find(params[:id])
	  render layout: "user"
  end

	private

	def user_params
		params.require(:user).permit(:profile[:personaldata]['name'], :profile[:personaldata]['phone'])
	end
end
