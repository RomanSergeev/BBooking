module UsersService

  def find_user
    @user = User.preload(:profile, :calendar).find(params[:id])
  end

  def require_profile(user = current_user)
    unless user.profile.present?
      redirect_to user_path(user),
                  notice: 'This action requires ' +
                    (user.id == current_user.id ? 'your' : 'user\'s') +
                    ' profile fulfilled.'
    end
  end

end