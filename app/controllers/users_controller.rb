class UsersController < ApplicationController
  before_action :load_user, only: [:show, :update]
  layout 'user'

  def update
    if @user.update(personaldata: params[:personaldata])
      render 'show'
    else
      redirect_to edit_profile_path
    end
  end

  private

  def load_user
    @user = User.preload(:profile).find(params[:id])
  end

  def user_params
    params.require(:user).permit(:profile[:personaldata]['name'], :profile[:personaldata]['phone'])
  end
end
