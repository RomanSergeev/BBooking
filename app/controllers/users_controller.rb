class UsersController < ApplicationController
  layout 'user' # why isn't it set automatically?

  def show
    set_services
    user = @users_service.find_user(params)
    init_presenter
    render 'show', locals: { view_data: @users_presenter.show_data(user, current_user) }
  end

  def edit_services
    set_services
    user = @users_service.find_user(params)
    require_permission?(user) or return
    require_profile?(user) or return
    @services = @users_service.find_user_services(user)
  end

  def show_services
    set_services
    user = @users_service.find_user(params)
    require_profile?(user) or return
    prevent_own_ordering?(user) or return
    @services = @users_service.find_user_services(user)
  end

  private

  def require_permission?(user)
    if user.id != current_user.id
      redirect_back fallback_location: user_path(current_user),
                    notice: 'Editing of another user is forbidden.'
      return false
    end
    true
  end

  def prevent_own_ordering?(user)
    if user.id == current_user.id
      redirect_to edit_services_path(user)
    end
  end

  def set_services
    @users_service = UsersService.new
  end

  def init_presenter
    @users_presenter = UsersPresenter.new
  end

end
