class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :authenticate_user!
  # rescue_from ActionController::InvalidAuthenticityToken do |exception|
  #   super
  # end

  def after_sign_in_path_for(user)
    user_path(user)
  end
end
