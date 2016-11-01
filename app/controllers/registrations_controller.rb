class RegistrationsController < Devise::RegistrationsController
	protected

	def after_sign_up_path_for(user)
		edit_profile_path(user)
	end

	def after_inactive_sign_up_path_for(user)
		edit_profile_path(user)
	end
end