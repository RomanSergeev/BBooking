class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit_services, :show_services]
  layout 'user' # why isn't it set automatically?

  def edit_services
    if current_user.id != @user.id
      redirect_back fallback_location: user_path(current_user),
                    notice: 'Editing of another user is forbidden.'
    else
      @services = Service.where(user_id: @user.id)
    end
  end

  def show_services
    @services = Service.where(user_id: @user.id)
    if current_user.id == @user.id
      redirect_to edit_services_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:profile[:personaldata]['name'], :profile[:personaldata]['phone'])
  end

  def find_user
    @user = User.preload(:profile).find(params[:id])
  end

end
