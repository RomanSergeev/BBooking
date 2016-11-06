class UsersController < ApplicationController
	before_action :find_user, only: [:show, :update, :edit_profile, :edit_services, :show_services]
	layout 'user' # why isn't it set automatically?

  def show
  end

  # def edit
		# redirect_to user_path
  # end

  def update
	  par = params[:personaldata]
	  @warning_message = Hash.new
	  unless /\A[A-Z][A-Za-z ]*\z/.match(par['name'])
			@warning_message[:name] = 'Name should start from big letter & contain only letters'
	  end
	  unless /\A\d{3}-\d{3}-\d{4}\z/.match(par['phone'])
			@warning_message[:phone] = 'Phone should be correct'
	  end
		if @warning_message.empty?
	    @user.profile.update(personaldata: par)
	    render 'show'
	  else
			redirect_to edit_profile_path message: @warning_message
		end
  end

	def edit_profile
		if current_user.id != @user.id
			redirect_to user_path(current_user), notice: 'Editing of another user is forbidden.'
		end
	end

  def edit_services
	  if current_user.id != @user.id
		  redirect_back fallback_location: user_path(current_user), notice: 'Editing of another user is forbidden.'
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

  def find_user
	  @user = User.preload(:profile).find(params[:id])
  end

	def user_params
		params.require(:user).permit(:profile[:personaldata]['name'], :profile[:personaldata]['phone'])
	end
end
