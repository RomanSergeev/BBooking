class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(user)
    user_path(user)
  end

  def search
    set_services
    render 'search/index',
           layout: 'search',
           locals: {
             view_data: @application_service.search_results(params[:q])
           }
  end

  def require_profile?(user)
    unless user.profile.present?
      redirect_to user_path(user),
                  notice: 'This action requires ' +
                    (user.id == current_user.id ? 'your' : 'user\'s') +
                    ' profile fulfilled.'
      return false
    end
    true
  end

  private

  def set_services
    @application_service = ApplicationService.new
  end

end
