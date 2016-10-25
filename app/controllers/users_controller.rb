class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    render layout: "user"
  end

  def edit
    #@user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.name = params[:user][:name]
	  @user.update_attributes(name: params[:user][:name])
		redirect_to user_path #maybe routes are best
  end

	def edit_profile
		@user = User.preload(:profile).find(params[:id])
		render layout: "user"
	end

  def edit_services
	  @user = User.preload(:profile).find(params[:id])
	  render layout: "user"
  end
end
