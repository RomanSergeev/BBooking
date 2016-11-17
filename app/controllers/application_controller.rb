class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(user)
    user_path(user)
  end

  def search
    render 'search/index', layout: 'search'
  end

end
