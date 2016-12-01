class UsersController < ApplicationController
  include UsersService
  layout 'user' # why isn't it set automatically?

  def show
    find_user
  end

  def edit_services
    require_profile
    find_user
    if current_user.id != @user.id
      redirect_back fallback_location: user_path(current_user),
                    notice: 'Editing of another user is forbidden.'
    else
      @services = Service.where(user_id: @user.id)
    end
  end

  def show_services
    find_user
    @services = Service.where(user_id: @user.id)
    if current_user.id == @user.id
      redirect_to edit_services_path(@user)
    end
  end

end
