class UsersService

  def find_user(params)
    User.preload(:profile, :calendar).find(params[:user_id] || params[:id])
  end

  def find_user_services(user)
    Service.where(user_id: user.id)
  end

end