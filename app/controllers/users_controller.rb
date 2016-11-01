class UsersController < ApplicationController
  def show
	  @user = User.preload(:profile).find(params[:id])
    render layout: 'user'
  end

  # def edit
		# redirect_to user_path
  # end

  def update
	  @user = User.preload(:profile).find(params[:id])
	  par = params[:personaldata]
	  @warning_message = Hash.new
	  unless /\A[A-Z][A-Za-z ]*\z/.match(par['name'])
			@warning_message[:name] = 'Name should start from big letter & contain only letters'
	  end
	  unless /\A\d{3}-\d{3}-\d{4}\z/.match(par['phone'])
			@warning_message[:phone] = 'Phone should be correct'
	  end
		if @warning_message.empty?
	    @user.profile.update(personaldata: params[:personaldata])
	    render 'show', layout: 'user'
	  else
			redirect_to edit_profile_path message: @warning_message
		end
  end

	def edit_profile
		@user = User.preload(:profile).find(params[:id])
		render layout: 'user'
	end

  def edit_services
	  @user = User.preload(:profile).find(params[:id])
	  render layout: 'user'
  end

	private

	def user_params
		params.require(:user).permit(:profile[:personaldata]['name'], :profile[:personaldata]['phone'])
	end
end
