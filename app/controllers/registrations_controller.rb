class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(user)
    new_profile_path from_creation: true
  end

  def after_inactive_sign_up_path_for(user)
    new_profile_path from_creation: true
  end
end