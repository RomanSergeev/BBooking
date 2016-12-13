class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  include ApplicationService

  def after_sign_in_path_for(user)
    user_path(user)
  end

  def search
    render 'search/index', layout: 'search', locals: { view_data: search_results(params[:q]) }
  end

end
